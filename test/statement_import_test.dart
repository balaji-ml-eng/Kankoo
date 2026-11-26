import 'dart:convert';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kankoo/core/money_minor.dart';
import 'package:kankoo/data/db/database.dart';
import 'package:kankoo/ingestion/statements/statement_csv.dart';
import 'package:kankoo/ingestion/statements/statement_importer.dart';

const bankCsv = '''Date,Description,Debit,Credit,Balance,Reference,Transaction ID
01/11/2026,"AWS, India",1180.00,,8820.00,R000001,TX001
02/11/2026,Client settlement,,5000.00,13820.00,R000002,TX002
03/11/2026,Office rent,3000.00,,10820.00,R000003,TX003
''';

PreviewRequest request({
  String csv = bankCsv,
  String opening = '10000',
  String closing = '10820',
  StatementMapping? mapping,
}) {
  final source = CsvStatement.decode(utf8.encode(csv));
  return PreviewRequest(source, mapping ?? StatementMapping.guess(source.records.first), opening, closing);
}

void main() {
  group('exact integer rupees', () {
    test('Indian grouping, fractions and signed balances round trip exactly', () {
      expect(parseInrMinor('₹1,24,500.01'), 12450001);
      expect(formatInrMinor(12450001), '₹1,24,500.01');
      expect(parseInrMinor('0.01'), 1);
      expect(parseInrMinor('25.00 DR', signed: true), -2500);
      expect(parseInrMinor('(25.00)', signed: true), -2500);
      expect(formatInrMinor(-2500), '−₹25.00');
      expect(formatInrMinor(0), '₹0.00');
    });
    test('never silently rounds or accepts malformed grouping', () {
      for (final value in ['12.501', '1,23.00', 'NaN', '1e3', '-1.00', '1.2.3', '9999999999999999999999']) {
        expect(() => parseInrMinor(value), throwsFormatException, reason: value);
      }
    });
  });
  group('statement preview', () {
    test('quoted descriptions and all running balances reconcile', () {
      final p = buildStatementPreview(request());
      expect(p.balanced, isTrue);
      expect(p.debitMinor, 418000);
      expect(p.creditMinor, 500000);
      expect(p.calculatedClosing, 1082000);
      expect(p.rows.first.description, 'AWS, India');
    });
    test('a closing mismatch blocks import', () {
      final p = buildStatementPreview(request(closing: '10821'));
      expect(p.differenceMinor, -100);
      expect(p.balanced, isFalse);
    });
    test('a bad intermediate balance blocks otherwise balanced totals', () {
      final p = buildStatementPreview(request(csv: bankCsv.replaceFirst('8820.00', '8821.00')));
      expect(p.differenceMinor, 0);
      expect(p.balanced, isFalse);
      expect(p.issues.single, contains('Row 2'));
    });
    test('both declared balances are required, including a valid zero', () {
      expect(buildStatementPreview(request(opening: '')).balanced, isFalse);
      expect(buildStatementPreview(request(closing: '')).balanced, isFalse);
      final p = buildStatementPreview(request(csv: 'Date,Description,Debit,Credit\n01/11/2026,Payment,1,,\n'));
      expect(p.balanced, isFalse);
      expect(
        buildStatementPreview(
          request(csv: 'Date,Description,Debit,Credit\n01/11/2026,Payment,1,\n', opening: '1', closing: '0'),
        ).balanced,
        isTrue,
      );
    });
    test('ambiguous ordering, invalid dates and invalid rows never partially pass', () {
      for (final text in [
        bankCsv.replaceFirst('01/11/2026', '31/02/2026'),
        bankCsv.replaceFirst('1180.00', '1180.001'),
        bankCsv.replaceFirst('TX002', 'TX001'),
        bankCsv.replaceFirst('1180.00,,', '1180.00,50.00,'),
        bankCsv.replaceFirst('1180.00,,', '0.00,,'),
      ]) {
        final p = buildStatementPreview(request(csv: text));
        expect(p.issues, isNotEmpty);
        expect(p.balanced, isFalse);
      }
    });
    test('newest-first statements are checked in chronological order', () {
      const csv =
          'Date,Description,Debit,Credit,Balance\n03/11/2026,Rent,3000,,10820\n02/11/2026,Client,,5000,13820\n01/11/2026,AWS,1180,,8820\n';
      final m = StatementMapping(date: 0, description: 1, debit: 2, credit: 3, balance: 4, newestFirst: true);
      expect(buildStatementPreview(request(csv: csv, mapping: m)).balanced, isTrue);
      expect(buildStatementPreview(request(csv: csv)).balanced, isFalse);
    });
    test('amount/direction and semicolon exports are supported', () {
      const csv =
          'Date;Description;Amount;Type;Balance\n01/11/2026;Hosting;100;DR;900\n02/11/2026;Client;200;CR;1100\n';
      expect(buildStatementPreview(request(csv: csv, opening: '1000', closing: '1100')).balanced, isTrue);
    });
    test('malformed CSV quotes are rejected instead of losing fields', () {
      for (final text in ['A,B\n"one,two', 'A,B\n"one"garbage,two', 'A,B\no"ne,two']) {
        expect(() => CsvStatement.decode(utf8.encode(text)), throwsFormatException);
      }
    });
  });

  group('atomic import and deduplication', () {
    late AppDatabase db;
    late StatementImporter importer;
    late int account;
    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      importer = StatementImporter(db);
      account = await db.addAccount(name: 'Agency bank', kind: AccountKind.bank, color: 0, currency: 'INR');
    });
    tearDown(() => db.close());
    test('commits rows, evidence, source records and verified totals together', () async {
      final result = await importer.commit(request(), accountId: account, fileName: 'bank.csv');
      expect(result.added, 3);
      expect(await db.select(db.transactions).get(), hasLength(3));
      expect(await db.select(db.sourceEvents).get(), hasLength(3));
      expect(await db.select(db.rawMessages).get(), hasLength(3));
      final job = (await db.select(db.importJobs).get()).single;
      expect(job.addedCount + job.matchedCount + job.skippedCount, 3);
      expect(job.openingMinor + job.creditMinor - job.debitMinor, job.closingMinor);
      expect((await db.select(db.reviewEvents).get()).single.action, 'statement_imported');
    });
    test('exact duplicate file cannot add rows twice', () async {
      await importer.commit(request(), accountId: account, fileName: 'bank.csv');
      await expectLater(
        importer.commit(request(), accountId: account, fileName: 'renamed.csv'),
        throwsA(isA<StatementImportException>()),
      );
      expect(await db.select(db.transactions).get(), hasLength(3));
      expect(await db.select(db.importJobs).get(), hasLength(1));
    });
    test('source and import accounts cannot be changed into inconsistent evidence', () async {
      final result = await importer.commit(request(), accountId: account, fileName: 'bank.csv');
      final other = await db.addAccount(name: 'Other bank', kind: AccountKind.bank, color: 1);
      await expectLater(
        db.customStatement('UPDATE import_jobs SET source_account_id=$other WHERE id=${result.jobId}'),
        throwsA(anything),
      );
      await expectLater(db.customStatement('UPDATE source_events SET source_account_id=$other'), throwsA(anything));
      expect((await db.select(db.importJobs).getSingle()).sourceAccountId, account);
    });
    test('reformatted or overlapping exports retain stable bank identities', () async {
      await importer.commit(request(), accountId: account, fileName: 'bank.csv');
      final result = await importer.commit(
        request(csv: bankCsv.replaceAll('\n', '\r\n')),
        accountId: account,
        fileName: 'bank-again.csv',
      );
      expect(result.added, 0);
      expect(result.skipped, 3);
      expect(await db.select(db.transactions).get(), hasLength(3));
    });
    test('deleted rows are not resurrected through another export', () async {
      await importer.commit(request(), accountId: account, fileName: 'bank.csv');
      await db.deleteTxn((await db.select(db.transactions).get()).first.id);
      final result = await importer.commit(
        request(csv: '\ufeff$bankCsv'),
        accountId: account,
        fileName: 'again.csv',
      );
      expect(result.skipped, 3);
      expect(await db.select(db.transactions).get(), hasLength(2));
    });
    test('mismatch and conflicting bank IDs roll back every new write', () async {
      await expectLater(
        importer.commit(
          request(closing: '1'),
          accountId: account,
          fileName: 'bad.csv',
        ),
        throwsA(isA<StatementImportException>()),
      );
      expect(await db.select(db.importJobs).get(), isEmpty);
      await importer.commit(request(), accountId: account, fileName: 'bank.csv');
      final changed = bankCsv
          .replaceFirst('1180.00', '1181.00')
          .replaceFirst('8820.00', '8819.00')
          .replaceFirst('13820.00', '13819.00')
          .replaceFirst('10820.00', '10819.00');
      await expectLater(
        importer.commit(
          request(csv: changed, closing: '10819'),
          accountId: account,
          fileName: 'conflict.csv',
        ),
        throwsA(isA<StatementImportException>()),
      );
      expect(await db.select(db.transactions).get(), hasLength(3));
      expect(await db.select(db.importJobs).get(), hasLength(1));
    });
    test('strong reference match retains the user’s existing edits', () async {
      final id = await db.addManual(
        amountMinor: 118000,
        direction: TxnDirection.debit,
        at: DateTime(2026, 11, 1),
        accountId: account,
        merchant: 'Edited vendor',
        note: 'Keep this purpose',
      );
      await (db.update(
        db.transactions,
      )..where((t) => t.id.equals(id))).write(const TransactionsCompanion(reference: Value('R000001')));
      final result = await importer.commit(request(), accountId: account, fileName: 'bank.csv');
      expect(result.matched, 1);
      expect(result.added, 2);
      final retained = await (db.select(db.transactions)..where((t) => t.id.equals(id))).getSingle();
      expect(retained.note, 'Keep this purpose');
      expect(retained.merchant, 'Edited vendor');
    });
    test('equal amounts without a shared reference are flagged, never auto-merged', () async {
      await db.addManual(
        amountMinor: 118000,
        direction: TxnDirection.debit,
        at: DateTime(2026, 11, 1),
        accountId: account,
      );
      final result = await importer.commit(request(), accountId: account, fileName: 'bank.csv');
      expect(result.added, 3);
      expect(result.matched, 0);
      expect(await db.select(db.transactions).get(), hasLength(4));
    });
    test('source identities are account-scoped', () async {
      await importer.commit(request(), accountId: account, fileName: 'bank.csv');
      final second = await db.addAccount(name: 'Second account', kind: AccountKind.bank, color: 0, currency: 'INR');
      expect((await importer.commit(request(), accountId: second, fileName: 'bank.csv')).added, 3);
    });
  });
}
