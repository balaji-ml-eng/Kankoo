import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kankoo/data/backup/data_export.dart';
import 'package:kankoo/data/db/database.dart';
import 'package:kankoo/documents/vault/pdf_vault.dart';
import 'package:kankoo/exports/ca_bundle.dart';
import 'package:kankoo/ingestion/statements/statement_importer.dart';
import 'package:kankoo/reconciliation/reconciliation_service.dart';
import 'package:kankoo/tax_checks/invoice_validation.dart';

import 'pdf_vault_test.dart' show VaultSecrets, invoicePdf;
import 'statement_import_test.dart' show request;

void main() {
  final month = DateTime(2026, 11);
  late AppDatabase db;
  late Directory dir;
  late VaultSecrets secrets;
  late PdfVault vault;
  late ReconciliationService review;
  late CaExportService exporter;
  var sequence = 0;
  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    dir = Directory.systemTemp.createTempSync('kankoo_ca_');
    secrets = VaultSecrets();
    vault = PdfVault(db: db, directory: dir, secrets: secrets);
    review = ReconciliationService(
      db,
      verifyDocument: (d) async {
        await vault.readPdf(d);
      },
    );
    exporter = CaExportService(db, readPdf: vault.readPdf, now: () => DateTime.utc(2026, 11, 26, 12));
    sequence = 0;
  });
  tearDown(() async {
    await db.close();
    await dir.delete(recursive: true);
  });
  Future<int> payment(
    int amount, {
    DateTime? date,
    String currency = 'INR',
    TxnDirection direction = TxnDirection.debit,
    String merchant = 'AWS India',
  }) => db.addManual(
    amountMinor: amount,
    direction: direction,
    at: date ?? DateTime(2026, 11, 2),
    currency: currency,
    merchant: merchant,
  );
  Future<Document> document() async {
    final d = await vault.addPdf([
      ...invoicePdf,
      ...utf8.encode('\n% ${++sequence}\n'),
    ], originalName: 'original-$sequence.pdf');
    await (db.update(db.documents)..where((t) => t.id.equals(d.id))).write(DocumentsCompanion(createdAt: Value(month)));
    return (db.select(db.documents)..where((t) => t.id.equals(d.id))).getSingle();
  }

  Future<int> invoice(int amount, {DateTime? date, String vendor = 'AWS India', String kind = 'invoice'}) async =>
      review.saveInvoice(
        InvoiceDraft(
          documentId: (await document()).id,
          vendor: vendor,
          number: 'INV-$sequence',
          date: date ?? month,
          kind: kind,
          amounts: InvoiceAmounts(taxable: amount, total: amount),
        ),
      );
  Map<String, List<int>> unzip(CaBundle bundle) => {
    for (final f in ZipDecoder().decodeBytes(bundle.bytes)) f.name: f.content,
  };
  String contents(Map<String, List<int>> files, String path) => utf8.decode(files[path]!);

  test('ZIP verifies every original PDF, manifest and immutable database snapshot', () async {
    final id = await payment(118001, merchant: '=HYPERLINK("evil")');
    await review.classify(id, 5000, purpose: 'Client infrastructure');
    final inv = await invoice(118001, vendor: '../../AWS / India');
    await review.link(id, inv, 118001);
    final doc = await db.select(db.documents).getSingle();
    final original = await vault.readPdf(doc);
    final ciphertext = await File('${dir.path}/${doc.encryptedFilePath}').readAsBytes();
    final bundle = await exporter.create(month), files = unzip(bundle);
    expect(bundle.fileName, 'kankoo-ca-2026-11-export-1.zip');
    final manifest = jsonDecode(contents(files, 'manifest.json')) as Map;
    final entries = manifest['files'] as List;
    expect(entries.map((f) => f['path']).toSet(), files.keys.where((p) => p != 'manifest.json').toSet());
    for (final entry in entries) {
      expect(files[entry['path']]!.length, entry['bytes']);
      expect(sha256.convert(files[entry['path']]!).toString(), entry['sha256']);
    }
    final pdfPath = files.keys.singleWhere((p) => p.endsWith('.pdf'));
    expect(pdfPath, startsWith('invoices/2026-11-01_'));
    expect(pdfPath.contains('..'), isFalse);
    expect(files[pdfPath], original);
    expect(await File('${dir.path}/${doc.encryptedFilePath}').readAsBytes(), ciphertext);
    expect(dir.listSync(), hasLength(1));
    final run = await db.select(db.exportRuns).getSingle();
    expect(run.manifestSha256, sha256.convert(files['manifest.json']!).toString());
    expect(run.manifestSha256, bundle.manifestSha256);
    expect((run.periodStart, run.periodEnd, run.includedCount), (month, DateTime(2026, 12), 1));
    final records = jsonDecode(contents(files, 'records.json')) as List;
    final items = await db.select(db.exportItems).get();
    expect(items, hasLength(3));
    for (final item in items) {
      final record = records.singleWhere((r) => r['entity_type'] == item.entityType && r['entity_id'] == item.entityId);
      expect(item.snapshotJson, canonicalJson(record['snapshot']));
      expect(item.contentHash, sha256.convert(utf8.encode(item.snapshotJson)).toString());
      expect(record['content_sha256'], item.contentHash);
    }
    expect(contents(files, 'ledger.csv'), contains("'=HYPERLINK"));
    expect(contents(files, 'ledger.csv'), contains('"590.01"'));
    expect(contents(files, 'ledger.csv'), contains('Evidence Matched'));
    expect(contents(files, 'audit.csv'), contains('payment_allocations'));
    await review.classify(id, 2500);
    await exporter.create(month);
    expect(
      (await (db.select(db.exportItems)..where((i) => i.exportRunId.equals(run.id))).get()).map((i) => i.snapshotJson),
      unorderedEquals(items.map((i) => i.snapshotJson)),
    );
    await expectLater(db.customStatement('UPDATE export_runs SET included_count = 0'), throwsA(anything));
    await expectLater(db.customStatement('DELETE FROM export_items'), throwsA(anything));
    await expectLater(db.customStatement('DELETE FROM export_runs'), throwsA(anything));
    await expectLater(db.customStatement("UPDATE export_items SET snapshot_json = '{}'"), throwsA(anything));
  });

  test('all monthly rows retained, cross-month allocations separated, refund and combined links intact', () async {
    final a = await payment(6000), b = await payment(4000, date: DateTime(2026, 10, 30));
    final inv = await invoice(10000, date: DateTime(2026, 10, 28));
    await review.classify(a, 10000);
    await review.classify(b, 10000);
    await review.link(a, inv, 6000);
    await review.link(b, inv, 4000);
    final combined = await payment(3000), i1 = await invoice(1000), i2 = await invoice(2000);
    await review.classify(combined, 10000);
    await review.link(combined, i1, 1000);
    await review.link(combined, i2, 2000);
    final refund = await payment(500, direction: TxnDirection.credit),
        creditNote = await invoice(500, kind: 'credit_note');
    await review.classify(refund, 10000);
    await review.link(refund, creditNote, 500);
    final personal = await payment(123);
    await review.classify(personal, 0);
    await payment(250, currency: 'USD');
    await payment(1);
    final transfer = await payment(999);
    await (db.update(
      db.transactions,
    )..where((t) => t.id.equals(transfer))).write(const TransactionsCompanion(isTransfer: Value(true)));
    await document();
    final bundle = await exporter.create(month), files = unzip(bundle);
    expect(
      (
        bundle.preview.payments,
        bundle.preview.personal,
        bundle.preview.foreign,
        bundle.preview.transfers,
        bundle.preview.pdfs,
      ),
      (7, 1, 1, 1, 5),
    );
    final ledger = contents(files, 'ledger.csv');
    expect(ledger, contains('Personal'));
    expect(ledger, contains('Foreign currency: review separately'));
    expect(ledger, contains('Self-transfer'));
    expect(ledger, contains('Unreviewed'));
    expect(contents(files, 'related_payments.csv'), contains('"40.00"'));
    expect(ledger, isNot(contains('"40.00"')));
    expect(contents(files, 'allocations.csv'), contains('"refund"'));
    expect(contents(files, 'allocations.csv'), contains('"true"'));
    expect(contents(files, 'summary.csv'), contains('"INR","91.24","5.00","86.24"'));
    expect(files.keys.where((p) => p.contains('unassigned_')), hasLength(1));
  });

  test('integer paise, multi-currency decimals and sums beyond 64 bits stay exact', () async {
    for (var i = 0; i < 2101; i++) {
      await payment(9000000000000001);
    }
    await payment(12345, currency: 'KWD');
    await payment(4321, currency: 'JPY');
    final files = unzip(await exporter.create(month));
    expect(contents(files, 'ledger.csv'), contains('"90000000000000.01","9000000000000001"'));
    expect(contents(files, 'ledger.csv'), contains('"12.345","12345"'));
    expect(contents(files, 'ledger.csv'), contains('"4321","4321"'));
    expect(contents(files, 'summary.csv'), contains('"189090000000000021.01"'));
    expect(contents(files, 'summary.csv'), contains('"18909000000000002101"'));
    expect((jsonDecode(contents(files, 'records.json')) as List), hasLength(2103));
  });

  test('calendar boundaries are exclusive; uncertain payments never inflate reviewed business totals', () async {
    await payment(900, date: DateTime(2026, 10, 31, 23, 59));
    await payment(900, date: DateTime(2026, 12));
    final confirmed = await payment(101, date: month), uncertain = await payment(1000), duplicate = await payment(1000);
    await payment(2, date: DateTime(2026, 11, 30, 23, 59, 59));
    for (final id in [confirmed, uncertain, duplicate]) {
      await review.classify(id, 10000);
    }
    await (db.update(
      db.transactions,
    )..where((t) => t.id.equals(uncertain))).write(const TransactionsCompanion(status: Value(TxnStatus.needsReview)));
    await (db.update(
      db.transactions,
    )..where((t) => t.id.equals(duplicate))).write(TransactionsCompanion(duplicateOfId: Value(confirmed)));
    final bundle = await exporter.create(month), files = unzip(bundle);
    expect(bundle.preview.payments, 4);
    expect(contents(files, 'summary.csv'), contains('"INR","21.03","0.00","21.03","1.01"'));
    expect(contents(files, 'ledger.csv'), contains('"needsReview"'));
    expect(contents(files, 'ledger.csv'), contains('"possible_duplicate_of"'));
  });

  test('row limit rejects the whole export instead of truncating records', () async {
    await db.batch(
      (b) => b.insertAll(db.transactions, [
        for (var i = 0; i <= CaExportService.maxRows; i++)
          TransactionsCompanion.insert(
            amountMinor: 1,
            direction: TxnDirection.debit,
            occurredAt: month,
            mode: PaymentMode.other,
            status: TxnStatus.confirmed,
          ),
      ]),
    );
    await expectLater(exporter.create(month), throwsA(isA<CaExportException>()));
    expect(await db.select(db.exportRuns).get(), isEmpty);
    final count = db.transactions.id.count();
    expect((await (db.selectOnly(db.transactions)..addColumns([count])).getSingle()).read(count), 50001);
  });

  test('statement import reconciliation and source identities reach the bundle', () async {
    final account = await db.addAccount(name: 'Current', kind: AccountKind.bank, color: 1);
    await StatementImporter(db).commit(request(), accountId: account, fileName: 'bank.csv');
    final files = unzip(await exporter.create(month));
    expect(contents(files, 'statement_imports.csv'), contains('bank.csv'));
    expect(contents(files, 'source_events.csv').split('\r\n'), hasLength(5));
    expect(contents(files, 'statement_imports.csv'), contains('"opening_minor"'));
  });

  for (final failure in ['tampered', 'missing', 'wrong key', 'database']) {
    test('$failure aborts atomically and keeps ledger, audit, ciphertext and key', () async {
      await payment(1000);
      await invoice(1000);
      final doc = await db.select(db.documents).getSingle();
      final file = File('${dir.path}/${doc.encryptedFilePath}');
      if (failure == 'tampered') {
        final b = await file.readAsBytes();
        b[20] ^= 1;
        await file.writeAsBytes(b);
      }
      if (failure == 'missing') {
        await file.rename('${file.path}.held');
      }
      if (failure == 'wrong key') {
        secrets.key = 'b' * 64;
      }
      if (failure == 'database') {
        await db.customStatement(
          "CREATE TRIGGER reject_export BEFORE INSERT ON export_items BEGIN SELECT RAISE(ABORT, 'injected failure'); END",
        );
      }
      final key = secrets.key, filesBefore = dir.listSync().map((f) => f.path).toList();
      final auditBefore = await db.select(db.reviewEvents).get();
      await expectLater(exporter.create(month), throwsA(anything));
      expect(await db.select(db.exportRuns).get(), isEmpty);
      expect(await db.select(db.exportItems).get(), isEmpty);
      expect(await db.select(db.transactions).get(), hasLength(1));
      expect(await db.select(db.documents).get(), hasLength(1));
      expect((await db.select(db.reviewEvents).get()).length, auditBefore.length);
      expect(dir.listSync().map((f) => f.path), filesBefore);
      expect(secrets.key, key);
    });
  }

  test('revalidates linked invoice arithmetic; unlinked mismatch is labelled', () async {
    final p = await payment(1000), inv = await invoice(1000);
    await review.classify(p, 10000);
    await review.link(p, inv, 1000);
    await db
        .into(db.invoiceLines)
        .insert(
          InvoiceLinesCompanion.insert(
            invoiceId: inv,
            lineNumber: 1,
            description: 'Stale line total',
            taxRateBps: 0,
            taxableMinor: 999,
            totalMinor: 999,
          ),
        );
    await expectLater(exporter.create(month), throwsA(isA<CaExportException>()));
    expect(await db.select(db.exportRuns).get(), isEmpty);
    await review.unlink((await db.select(db.paymentAllocations).getSingle()).id);
    final files = unzip(await exporter.create(month));
    expect(contents(files, 'invoices.csv'), contains('"mismatch"'));
    expect(contents(files, 'audit.csv'), contains('delete'));
  });

  test('empty period records no receipt; invoice-only period is exportable', () async {
    await expectLater(exporter.create(month), throwsA(isA<CaExportException>()));
    expect(await db.select(db.exportRuns).get(), isEmpty);
    await document();
    final bundle = await exporter.create(month);
    expect((bundle.preview.payments, bundle.preview.pdfs), (0, 1));
  });

  test('v6 migration preserves export history and ledger, backup restore retains append guards', () async {
    final file = File('${dir.path}/migration.sqlite');
    var ledger = AppDatabase(NativeDatabase(file));
    try {
      await ledger.addManual(amountMinor: 101, direction: TxnDirection.debit, at: month, note: 'Retain me');
      final bundle = await CaExportService(ledger, readPdf: (_) async => throw StateError('No PDFs')).create(month);
      for (final table in ['export_runs', 'export_items']) {
        for (final action in ['update', 'delete']) {
          await ledger.customStatement('DROP TRIGGER ${table}_no_$action');
        }
      }
      await ledger.customStatement('PRAGMA user_version = 6');
      await ledger.close();
      ledger = AppDatabase(NativeDatabase(file));
      expect((await ledger.select(ledger.transactions).getSingle()).note, 'Retain me');
      expect((await ledger.select(ledger.exportRuns).getSingle()).manifestSha256, bundle.manifestSha256);
      expect(await ledger.customSelect('PRAGMA user_version').map((r) => r.data.values.single).getSingle(), 7);
      await expectLater(ledger.customStatement('DELETE FROM export_runs'), throwsA(anything));
      final backup = await DataExport(ledger).backupJson();
      await DataExport(db).restore(backup);
      expect((await db.select(db.exportRuns).getSingle()).manifestSha256, bundle.manifestSha256);
      await expectLater(db.customStatement('DELETE FROM export_items'), throwsA(anything));
      expect(await db.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
    } finally {
      await ledger.close();
    }
  });

  test('CSV quoting neutralizes formulas and retains multiline text and exact numeric strings', () {
    final text = utf8.decode(
      caCsv([
        ['=1+1', ' +cmd', '\t@SUM(A1)', '-bad', 'a,"b"\nc', '-1.23', '00123', null],
      ]),
    );
    expect(
      caCsv([
        ['test'],
      ]).take(3),
      [239, 187, 191],
    );
    expect(text, startsWith('"\'=1+1","\' +cmd","\'\t@SUM(A1)","\'-bad"'));
    expect(text, contains('"a,""b""\nc"'));
    expect(text, contains('"-1.23","00123",""\r\n'));
  });
}
