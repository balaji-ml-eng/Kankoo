import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kankoo/data/db/database.dart';
import 'package:kankoo/documents/vault/pdf_vault.dart';
import 'package:kankoo/ingestion/ingestion_service.dart';
import 'package:kankoo/ingestion/parser/parsed_txn.dart';
import 'package:kankoo/ingestion/statements/statement_importer.dart';
import 'package:kankoo/reconciliation/reconciliation_service.dart';
import 'package:kankoo/tax_checks/invoice_validation.dart';

import 'pdf_vault_test.dart' show VaultSecrets, invoicePdf;
import 'statement_import_test.dart' show request;

void main() {
  final month = DateTime(2026, 11);
  late AppDatabase db;
  late ReconciliationService service;
  var verifications = 0, documentSequence = 0;
  var rejectPdf = false;
  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    verifications = 0;
    rejectPdf = false;
    documentSequence = 0;
    service = ReconciliationService(
      db,
      verifyDocument: (_) async {
        verifications++;
        if (rejectPdf) throw const VaultException('PDF authentication failed');
      },
    );
  });
  tearDown(() => db.close());
  Future<int> payment(
    int amount, {
    String merchant = 'AWS India',
    TxnDirection direction = TxnDirection.debit,
    DateTime? date,
    String currency = 'INR',
  }) => db.addManual(
    amountMinor: amount,
    direction: direction,
    at: date ?? DateTime(2026, 11, 2),
    merchant: merchant,
    currency: currency,
  );
  Future<int> document() async {
    final hash = (++documentSequence).toRadixString(16).padLeft(64, '0');
    return db
        .into(db.documents)
        .insert(
          DocumentsCompanion.insert(
            sha256: hash,
            encryptedFilePath: '$hash.kpdf',
            originalName: 'invoice-$documentSequence.pdf',
            byteLength: 100,
          ),
        );
  }

  Future<int> invoice(int total, {String vendor = 'AWS India', String kind = 'invoice', DateTime? date}) async =>
      service.saveInvoice(
        InvoiceDraft(
          documentId: await document(),
          vendor: vendor,
          number: 'INV-$documentSequence',
          date: date ?? DateTime(2026, 11, 1),
          kind: kind,
          amounts: InvoiceAmounts(taxable: total, total: total),
        ),
      );
  Future<ReviewRow> row(int id) async =>
      (await service.loadMonth(month)).rows.singleWhere((r) => r.transaction.id == id);

  test('business share rounds once in paise without overflowing supported amounts', () {
    expect(businessMinor(101, 5000), 51);
    expect(businessMinor(9000000000000000, 10000), 9000000000000000);
    expect(businessMinor(9000000000000000, 3333), 2999700000000000);
  });
  test('personal, business and custom splits sync classification, status and audit', () async {
    final id = await payment(118000);
    expect((await row(id)).status, 'Unreviewed');
    await service.classify(id, 5000, purpose: ' Client infrastructure ');
    expect((await row(id)).businessShare, 59000);
    expect((await row(id)).status, 'Needs Evidence');
    final classification = await db.select(db.classifications).getSingle();
    expect(
      (classification.businessUseBps, classification.businessPurpose, classification.provenance),
      (5000, 'Client infrastructure', 'user'),
    );
    expect(classification.gstEligibilityStatus, 'not_assessed');
    await service.classify(id, 0);
    expect((await row(id)).status, 'Personal');
    await expectLater(service.classify(id, 10001), throwsArgumentError);
    expect((await row(id)).transaction.businessUseBps, 0);
    expect(await db.select(db.reviewEvents).get(), isNotEmpty);
  });
  test('merchant memory is exact, preserves user reviews, and applies to new debits only', () async {
    final first = await payment(1000);
    await service.classify(first, 5000, remember: true);
    final next = await payment(1000, merchant: 'AWS,  India');
    expect((await row(next)).classification?.provenance, 'rule');
    expect((await row(next)).transaction.businessUseBps, 5000);
    final credit = await payment(1000, direction: TxnDirection.credit);
    expect((await row(credit)).reviewed, isFalse);
    final unrelated = await payment(1000, merchant: 'AWS India Marketplace');
    expect((await row(unrelated)).reviewed, isFalse);
    await service.classify(next, 0);
    await service.applyRules(month);
    expect((await row(next)).transaction.businessUseBps, 0);
    final ruleEvents = await (db.select(
      db.reviewEvents,
    )..where((e) => e.entityType.equals('transaction') & e.entityId.equals(next))).get();
    expect(jsonDecode(ruleEvents.first.afterJson)['business_use_bps'], 5000);
    expect(ruleEvents.first.provenance, 'rule');
  });
  test('forgetting a rule changes future behavior without undoing recorded splits', () async {
    final id = await payment(1000);
    await service.classify(id, 10000, remember: true);
    await service.removeRule((await db.select(db.businessRules).getSingle()).id);
    final next = await payment(1000);
    expect((await row(next)).reviewed, isFalse);
    expect((await row(id)).transaction.businessUseBps, 10000);
    final short = await payment(1000, merchant: 'EY');
    await service.classify(short, 5000, remember: true);
    expect((await row(await payment(1000, merchant: 'EY'))).classification?.provenance, 'rule');
  });
  test('saved rules apply to CSV and SMS ingestion without changing source identity', () async {
    final id = await payment(1000, merchant: 'AWS, India');
    await service.classify(id, 10000, remember: true);
    final account = await db.addAccount(name: 'Current', kind: AccountKind.bank, color: 1);
    await StatementImporter(db).commit(request(), accountId: account, fileName: 'bank.csv');
    final aws = (await service.loadMonth(month)).rows.where((r) => r.transaction.amountMinor == 118000).single;
    expect(aws.classification?.provenance, 'rule');
    expect(await db.select(db.sourceEvents).get(), hasLength(3));
    await service.classify(await payment(1000, merchant: 'SWIGGY'), 5000, remember: true);
    await IngestionService(db).ingest([
      RawInput(
        source: SourceKind.sms,
        externalId: 'sms-rule',
        sender: 'VM-HDFCBK',
        body: 'Sent Rs.250.00 From HDFC Bank A/C *4521 To SWIGGY On 12/11/26 Ref 528512345678',
        receivedAt: DateTime(2026, 11, 12),
      ),
    ]);
    final swiggy = (await service.loadMonth(month)).rows.singleWhere((r) => r.transaction.amountMinor == 25000);
    expect(swiggy.transaction.businessUseBps, 5000);
  });
  test('matching covers the gross payment while business use and GST remain separate', () async {
    final id = await payment(118000), inv = await invoice(118000);
    await service.classify(id, 5000);
    await service.link(id, inv, 118000);
    expect((await row(id)).status, 'Evidence Matched');
    expect((await row(id)).businessShare, 59000);
    expect((await db.select(db.invoices).getSingle()).gstEligibilityStatus, 'not_assessed');
    expect(verifications, 2);
    await expectLater(service.classify(id, 0), throwsStateError);
    await service.unlink((await db.select(db.paymentAllocations).getSingle()).id);
    expect((await row(id)).status, 'Needs Evidence');
    await service.classify(id, 0);
    expect((await row(id)).status, 'Personal');
  });
  test('one payment can cover multiple invoices and multiple payments can cover one invoice', () async {
    final first = await payment(1000), second = await payment(500);
    final a = await invoice(600), b = await invoice(900);
    await service.classify(first, 10000);
    await service.classify(second, 10000);
    await service.link(first, a, 600);
    await service.link(first, b, 400);
    expect((await row(first)).status, 'Evidence Matched');
    await service.link(second, b, 300);
    expect((await row(second)).status, 'Needs Evidence');
    await service.link(second, b, 200);
    expect((await row(second)).status, 'Evidence Matched');
    expect(await db.select(db.paymentAllocations).get(), hasLength(3));
    await expectLater(service.link(second, b, 1), throwsA(isA<ReconciliationException>()));
  });
  test('stale suggestions and over-allocation roll back without audit pollution', () async {
    final id = await payment(1000), other = await payment(1000), inv = await invoice(1000);
    await service.classify(id, 10000);
    await service.classify(other, 10000);
    final stale = rankInvoices(await row(other), await service.loadMonth(month)).single;
    await service.link(id, inv, 1000);
    final auditCount = (await db.select(db.reviewEvents).get()).length;
    await expectLater(service.link(other, inv, stale.suggested), throwsA(isA<ReconciliationException>()));
    expect(await db.select(db.paymentAllocations).get(), hasLength(1));
    expect(await db.select(db.reviewEvents).get(), hasLength(auditCount));
    expect((await row(other)).status, 'Needs Evidence');
  });
  test('refunds consume paid balance and preserve dependency ordering', () async {
    final pay = await payment(1000),
        refund = await payment(200, direction: TxnDirection.credit),
        inv = await invoice(1000);
    await service.classify(pay, 10000);
    await service.classify(refund, 10000);
    await expectLater(service.link(refund, inv, 200), throwsA(isA<ReconciliationException>()));
    await service.link(pay, inv, 1000);
    await service.link(refund, inv, 200);
    expect((await row(refund)).status, 'Evidence Matched');
    expect((await service.loadMonth(month)).businessTotal, 800);
    final links = await db.select(db.paymentAllocations).get();
    await expectLater(service.unlink(links.singleWhere((p) => p.kind == 'payment').id), throwsA(anything));
    await service.unlink(links.singleWhere((p) => p.kind == 'refund').id);
    await service.unlink(links.singleWhere((p) => p.kind == 'payment').id);
    expect(await db.select(db.paymentAllocations).get(), isEmpty);
  });
  test('credit notes can support refunds but never debit payments', () async {
    final refund = await payment(500, direction: TxnDirection.credit),
        debit = await payment(500),
        inv = await invoice(500, kind: 'credit_note');
    await service.classify(refund, 10000);
    await service.classify(debit, 10000);
    await expectLater(service.link(debit, inv, 500), throwsA(isA<ReconciliationException>()));
    await service.link(refund, inv, 500);
    expect((await row(refund)).status, 'Evidence Matched');
  });
  test('missing or tampered PDF prevents invoice save and matching without losing data', () async {
    final id = await payment(1000), inv = await invoice(1000);
    await service.classify(id, 10000);
    rejectPdf = true;
    await expectLater(service.link(id, inv, 1000), throwsA(isA<VaultException>()));
    await expectLater(invoice(500), throwsA(isA<VaultException>()));
    expect(await db.select(db.paymentAllocations).get(), isEmpty);
    expect(await db.select(db.invoices).get(), hasLength(1));
  });
  test('real encrypted vault PDF is authenticated at entry and linking', () async {
    final dir = await Directory.systemTemp.createTemp('kankoo_evidence');
    try {
      final vault = PdfVault(db: db, directory: dir, secrets: VaultSecrets());
      service = ReconciliationService(
        db,
        verifyDocument: (d) async {
          await vault.readPdf(d);
        },
      );
      final doc = await vault.addPdf(invoicePdf, originalName: 'aws.pdf');
      final inv = await service.saveInvoice(
        InvoiceDraft(
          documentId: doc.id,
          vendor: 'AWS',
          number: '1',
          date: month,
          amounts: const InvoiceAmounts(taxable: 1000, total: 1000),
        ),
      );
      final id = await payment(1000);
      await service.classify(id, 10000);
      final file = File('${dir.path}/${doc.encryptedFilePath}');
      final bytes = await file.readAsBytes();
      bytes[20] ^= 1;
      await file.writeAsBytes(bytes, flush: true);
      await expectLater(service.link(id, inv, 1000), throwsA(isA<VaultException>()));
      expect((await row(id)).status, 'Needs Evidence');
      expect(await file.exists(), isTrue);
    } finally {
      await dir.delete(recursive: true);
    }
  });
  test('invoice entry validates exact tax totals and does not duplicate an attached PDF', () async {
    final doc = await document();
    InvoiceDraft draft(InvoiceAmounts amounts) => InvoiceDraft(
      documentId: doc,
      vendor: 'AWS',
      number: 'A-1',
      date: month,
      amounts: amounts,
      supplierGstin: '27AAPFU0939F1ZV',
    );
    await expectLater(
      service.saveInvoice(draft(const InvoiceAmounts(taxable: 1000, cgst: 90, sgst: 90, total: 1179))),
      throwsA(isA<ReconciliationException>()),
    );
    final inv = await service.saveInvoice(draft(const InvoiceAmounts(taxable: 1000, cgst: 90, sgst: 90, total: 1180)));
    await expectLater(
      service.saveInvoice(draft(const InvoiceAmounts(taxable: 1000, total: 1000))),
      throwsA(isA<ReconciliationException>()),
    );
    await service.saveInvoice(draft(const InvoiceAmounts(taxable: 2000, total: 2000)), invoiceId: inv);
    expect((await db.select(db.invoices).getSingle()).totalMinor, 2000);
    expect(await db.select(db.invoices).get(), hasLength(1));
    expect((await db.select(db.reviewEvents).get()).last.action, 'details_edited');
  });
  test('ranking is deterministic and cannot link unconfirmed or personal payments', () async {
    final id = await payment(1000);
    final exact = await invoice(1000), other = await invoice(1000, vendor: 'Other vendor', date: DateTime(2026, 9, 1));
    await expectLater(service.link(id, exact, 1000), throwsA(isA<ReconciliationException>()));
    await service.classify(id, 10000);
    final suggestions = rankInvoices(await row(id), await service.loadMonth(month));
    expect(suggestions.map((s) => s.invoice.id), [exact, other]);
    expect(suggestions.first.reasons, contains('Vendor name overlaps'));
    await (db.update(
      db.transactions,
    )..where((t) => t.id.equals(id))).write(const TransactionsCompanion(status: Value(TxnStatus.needsReview)));
    await expectLater(service.link(id, exact, 1000), throwsA(isA<ReconciliationException>()));
    await service.confirm(id);
    await service.link(id, exact, 1000);
    expect((await row(id)).status, 'Evidence Matched');
  });
  test('month boundaries, foreign transactions and self-transfers do not enter the workspace', () async {
    final inside = await payment(1000, date: DateTime(2026, 11, 30, 23, 59));
    await payment(1000, date: DateTime(2026, 12, 1));
    await payment(1000, currency: 'USD');
    final transfer = await payment(1000);
    await db.setTransfer(transfer, true);
    expect((await service.loadMonth(month)).rows.map((r) => r.transaction.id), [inside]);
    await expectLater(service.classify(transfer, 10000), throwsStateError);
  });
  test('existing activity actions preserve linked evidence and refresh status after amount edits', () async {
    final id = await payment(1000), other = await payment(1000), inv = await invoice(1000);
    await service.classify(id, 10000);
    await service.link(id, inv, 1000);
    await expectLater(db.deleteTxn(id), throwsStateError);
    await expectLater(db.mergeInto(id, other), throwsStateError);
    await expectLater(db.setTransfer(id, true), throwsStateError);
    final original = (await row(id)).transaction;
    Future<void> edit(int minor) => db.updateTxn(
      id,
      amountMinor: minor,
      direction: original.direction,
      occurredAt: original.occurredAt,
      merchant: original.merchant,
      accountId: original.accountId,
      note: 'Keep evidence',
    );
    await edit(1200);
    expect((await row(id)).transaction.reviewStatus, 'needs_evidence');
    expect((await row(id)).allocated, 1000);
    await expectLater(edit(999), throwsA(anything));
    expect((await row(id)).transaction.amountMinor, 1200);
    expect(await db.select(db.rawMessages).get(), hasLength(2));
    await service.unlink((await db.select(db.paymentAllocations).getSingle()).id);
    await expectLater(db.mergeInto(id, other), throwsStateError);
    expect((await row(id)).classification, isNotNull);
  });
  test('saved rules can be applied to existing unreviewed rows and preserve Unicode merchants', () async {
    final old = await payment(1000, merchant: 'தமிழ் கடை');
    final reviewed = await payment(1000, merchant: 'தமிழ் கடை');
    await service.classify(reviewed, 0);
    final source = await payment(1000, merchant: 'தமிழ் கடை');
    await service.classify(source, 5000, remember: true);
    expect(await service.applyRules(month), 1);
    expect((await row(old)).transaction.businessUseBps, 5000);
    expect((await row(reviewed)).status, 'Personal');
  });
  test('workspace does not truncate the month at 2000 transactions', () async {
    await db.batch(
      (batch) => batch.insertAll(db.transactions, [
        for (var i = 0; i < 2101; i++)
          TransactionsCompanion.insert(
            amountMinor: 100,
            direction: TxnDirection.debit,
            occurredAt: month,
            merchant: Value('Consulting $i'),
            mode: PaymentMode.other,
            status: TxnStatus.confirmed,
          ),
      ]),
    );
    expect((await service.loadMonth(month)).rows, hasLength(2101));
  });
  test('v5 to v6 migration preserves the ledger and installs correct rule provenance audit', () async {
    final dir = await Directory.systemTemp.createTemp('kankoo_v6');
    final file = File('${dir.path}/ledger.sqlite');
    var ledger = AppDatabase(NativeDatabase(file));
    try {
      late int id;
      await ledger.transaction(() async {
        id = await ledger.addManual(
          amountMinor: 1000,
          direction: TxnDirection.debit,
          at: month,
          merchant: 'AWS',
          note: 'Keep v5 notes',
        );
        await ledger
            .into(ledger.businessRules)
            .insert(BusinessRulesCompanion.insert(merchantPattern: 'aws', businessUseBps: 5000));
        await ledger.customStatement('DROP TRIGGER audit_transaction_business_use');
        await ledger.customStatement('PRAGMA user_version = 5');
      });
      await ledger.close();
      ledger = AppDatabase(NativeDatabase(file));
      expect(await ledger.applyBusinessRule(id), isTrue);
      final txn = await ledger.select(ledger.transactions).getSingle();
      expect((txn.id, txn.note, txn.amountMinor, txn.businessUseBps), (id, 'Keep v5 notes', 1000, 5000));
      final audit = await (ledger.select(
        ledger.reviewEvents,
      )..where((e) => e.entityType.equals('transaction') & e.entityId.equals(id))).getSingle();
      expect(audit.provenance, 'rule');
      expect(await ledger.customSelect('PRAGMA user_version').map((r) => r.data.values.single).getSingle(), 7);
      expect(await ledger.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
    } finally {
      await ledger.close();
      await dir.delete(recursive: true);
    }
  });
  test('monthly stream emits classification changes when transaction count stays constant', () async {
    final id = await payment(1000);
    final events = <ReviewSnapshot>[];
    final updated = Completer<void>();
    final sub = service.watchMonth(month).listen((snapshot) {
      events.add(snapshot);
      if (snapshot.rows.single.transaction.businessUseBps == 5000 && !updated.isCompleted) updated.complete();
    });
    try {
      while (events.isEmpty) {
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
      await service.classify(id, 5000);
      await updated.future.timeout(const Duration(seconds: 5));
      expect(events.last.businessTotal, 500);
    } finally {
      await sub.cancel();
    }
  });
}
