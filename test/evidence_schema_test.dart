import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kankoo/data/backup/data_export.dart';
import 'package:kankoo/data/db/database.dart';

import 'support/legacy_ledger.dart';

void main() {
  late AppDatabase db;
  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
  });
  tearDown(() => db.close());

  Future<int> transaction(int minor, {TxnDirection direction = TxnDirection.debit}) =>
      db.addManual(amountMinor: minor, direction: direction, at: DateTime(2026, 11, 1));
  Future<int> invoice(int minor) async {
    final hash = 'a' * 64;
    final doc = await db
        .into(db.documents)
        .insert(
          DocumentsCompanion.insert(
            sha256: hash,
            encryptedFilePath: '$hash.kpdf',
            originalName: 'invoice.pdf',
            byteLength: 100,
          ),
        );
    return db
        .into(db.invoices)
        .insert(
          InvoicesCompanion.insert(
            documentId: doc,
            vendorName: 'Consulting',
            invoiceNumber: 'INV-1',
            invoiceDate: DateTime(2026, 11, 1),
            taxableMinor: minor,
            totalMinor: minor,
            arithmeticStatus: const Value('consistent'),
          ),
        );
  }

  Future<int> allocate(int txn, int inv, int minor, {String kind = 'payment'}) => db
      .into(db.paymentAllocations)
      .insert(
        PaymentAllocationsCompanion.insert(transactionId: txn, invoiceId: inv, allocatedMinor: minor, kind: kind),
      );

  test('v4 migration preserves edits, raw links, IDs, balances and indexes', () async {
    final dir = await Directory.systemTemp.createTemp('kankoo_v4');
    final file = File('${dir.path}/ledger.sqlite');
    var ledger = AppDatabase(NativeDatabase(file));
    try {
      final account = await ledger.addAccount(name: 'Agency', kind: AccountKind.bank, color: 1);
      final id = await ledger.addManual(
        amountMinor: 118000,
        direction: TxnDirection.debit,
        at: DateTime(2026, 11, 1),
        accountId: account,
        note: 'Keep my edit',
      );
      await ledger
          .into(ledger.rawMessages)
          .insert(
            RawMessagesCompanion.insert(
              source: SourceKind.sms,
              externalId: 'sms-1',
              sender: 'BANK',
              body: 'original evidence',
              receivedAt: DateTime(2026, 11, 1),
              parseStatus: ParseStatus.parsed,
              transactionId: Value(id),
            ),
          );
      await makeV4Fixture(ledger);
      await ledger.close();
      ledger = AppDatabase(NativeDatabase(file));
      final row = await ledger.select(ledger.transactions).getSingle();
      expect((row.id, row.amountMinor, row.accountId, row.note), (id, 118000, account, 'Keep my edit'));
      expect((row.businessUseBps, row.reviewStatus), (0, 'unreviewed'));
      expect(
        (await (ledger.select(
          ledger.rawMessages,
        )..where((r) => r.externalId.equals('sms-1'))).getSingle()).transactionId,
        id,
      );
      expect(await ledger.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
      final indexes = await ledger.customSelect('PRAGMA index_list(transactions)').get();
      expect(indexes.map((r) => r.read<String>('name')), contains('idx_txn_time'));
      await ledger
          .into(ledger.businessRules)
          .insert(BusinessRulesCompanion.insert(merchantPattern: 'aws', businessUseBps: 10000));
      expect(await ledger.select(ledger.reviewEvents).get(), hasLength(1));
    } finally {
      await ledger.close();
      await dir.delete(recursive: true);
    }
  });

  test('strict integers, percentage bounds, invoice math and foreign keys', () async {
    final txn = await transaction(100);
    await expectLater(db.customStatement('UPDATE transactions SET amount_minor=1.5 WHERE id=$txn'), throwsA(anything));
    await expectLater(
      db.customStatement('UPDATE transactions SET business_use_bps=10001 WHERE id=$txn'),
      throwsA(anything),
    );
    await expectLater(db.customStatement('UPDATE transactions SET account_id=999 WHERE id=$txn'), throwsA(anything));
    final inv = await invoice(100);
    await expectLater(db.customStatement('UPDATE invoices SET total_minor=101 WHERE id=$inv'), throwsA(anything));
    await expectLater(
      db.customStatement('UPDATE invoices SET igst_minor=1,cgst_minor=1 WHERE id=$inv'),
      throwsA(anything),
    );
    expect((await db.select(db.invoices).getSingle()).totalMinor, 100);
  });

  test('partial and combined payments cannot over-allocate either parent', () async {
    final inv = await invoice(1000), first = await transaction(600), second = await transaction(500);
    await allocate(first, inv, 600);
    await allocate(second, inv, 400);
    await expectLater(allocate(second, inv, 101), throwsA(anything));
    await expectLater(
      db.customStatement('UPDATE transactions SET amount_minor=599 WHERE id=$first'),
      throwsA(anything),
    );
    await expectLater(
      db.customStatement('UPDATE invoices SET taxable_minor=999,total_minor=999 WHERE id=$inv'),
      throwsA(anything),
    );
    expect(await db.select(db.paymentAllocations).get(), hasLength(2));
  });

  test('refunds require credit and a paid balance; deleting payment cannot orphan refund', () async {
    final inv = await invoice(1000), pay = await transaction(1000);
    final refund = await transaction(200, direction: TxnDirection.credit);
    await expectLater(allocate(refund, inv, 200, kind: 'refund'), throwsA(anything));
    final allocation = await allocate(pay, inv, 1000);
    await allocate(refund, inv, 200, kind: 'refund');
    await expectLater(
      (db.delete(db.paymentAllocations)..where((p) => p.id.equals(allocation))).go(),
      throwsA(anything),
    );
    await expectLater(db.customStatement('UPDATE transactions SET direction=0 WHERE id=$refund'), throwsA(anything));
    expect(await db.select(db.paymentAllocations).get(), hasLength(2));
  });

  test('classification audit records before/after and CA provenance; history is append-only', () async {
    final txn = await transaction(1000);
    final id = await db
        .into(db.classifications)
        .insert(ClassificationsCompanion.insert(transactionId: txn, businessUseBps: 5000, provenance: 'ca'));
    await (db.update(
      db.classifications,
    )..where((c) => c.id.equals(id))).write(const ClassificationsCompanion(businessUseBps: Value(10000)));
    final events = await db.select(db.reviewEvents).get();
    expect(events, hasLength(2));
    expect(events.last.provenance, 'ca');
    expect(jsonDecode(events.last.beforeJson)['business_use_bps'], 5000);
    expect(jsonDecode(events.last.afterJson)['business_use_bps'], 10000);
    await expectLater(db.customStatement("UPDATE review_events SET action='changed'"), throwsA(anything));
    await expectLater(db.delete(db.reviewEvents).go(), throwsA(anything));
  });

  test('backup restore keeps exact audit history and reinstalls guards', () async {
    await transaction(1000);
    await db
        .into(db.businessRules)
        .insert(BusinessRulesCompanion.insert(merchantPattern: 'aws', businessUseBps: 10000));
    final backup = await DataExport(db).backupJson();
    await DataExport(db).restore(backup);
    expect(await db.select(db.reviewEvents).get(), hasLength(1));
    final incomplete = jsonDecode(backup) as Map<String, dynamic>;
    (incomplete['tables'] as Map).remove('review_events');
    expect(() => DataExport(db).inspect(jsonEncode(incomplete)), throwsA(isA<BackupFormatException>()));
    await expectLater(db.delete(db.reviewEvents).go(), throwsA(anything));
    final damaged = jsonDecode(backup) as Map<String, dynamic>;
    damaged['tables']['business_rules'][0]['business_use_bps'] = 10001;
    await expectLater(DataExport(db).restore(jsonEncode(damaged)), throwsA(anything));
    expect((await db.select(db.businessRules).getSingle()).businessUseBps, 10000);
    await expectLater(db.delete(db.reviewEvents).go(), throwsA(anything));
  });
}
