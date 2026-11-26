import 'dart:convert';
import 'dart:math' as math;

import 'package:drift/drift.dart';

import '../core/money_minor.dart';
import '../data/db/database.dart';
import '../tax_checks/invoice_validation.dart';

class ReconciliationException implements Exception {
  const ReconciliationException(this.message);
  final String message;
  @override
  String toString() => message;
}

int businessMinor(int amountMinor, int bps) =>
    amountMinor ~/ 10000 * bps + ((amountMinor % 10000) * bps + 5000) ~/ 10000;

class ReviewRow {
  const ReviewRow(this.transaction, this.classification, this.links, this.invoices);
  final Transaction transaction;
  final Classification? classification;
  final List<PaymentAllocation> links;
  final Map<int, Invoice> invoices;
  int get allocated => links.fold(0, (sum, p) => sum + p.allocatedMinor);
  int get remaining => transaction.amountMinor - allocated;
  bool get reviewed => classification != null;
  int get businessShare => businessMinor(transaction.amountMinor, transaction.businessUseBps);
  String get status {
    if (!reviewed) return 'Unreviewed';
    if (transaction.businessUseBps == 0) return 'Personal';
    if (transaction.status == TxnStatus.needsReview) return 'Needs review';
    if (links.any((p) => invoices[p.invoiceId]?.arithmeticStatus != 'consistent') || remaining < 0) return 'Mismatch';
    return remaining == 0 ? 'Evidence Matched' : 'Needs Evidence';
  }
}

class ReviewSnapshot {
  const ReviewSnapshot(this.rows, this.invoices, this.documents, this.allocations, this.rules);
  final List<ReviewRow> rows;
  final List<Invoice> invoices;
  final List<Document> documents;
  final List<PaymentAllocation> allocations;
  final List<BusinessRule> rules;
  int get businessTotal => rows.fold(
    0,
    (sum, r) => sum + (r.transaction.direction == TxnDirection.debit ? r.businessShare : -r.businessShare),
  );
  int get needsEvidence => rows.where((r) => r.transaction.businessUseBps > 0 && r.status != 'Evidence Matched').length;
}

class InvoiceSuggestion {
  const InvoiceSuggestion(this.invoice, this.available, this.suggested, this.score, this.reasons);
  final Invoice invoice;
  final int available, suggested, score;
  final List<String> reasons;
}

int invoiceAvailable(Invoice invoice, List<PaymentAllocation> allocations, {required bool refund}) {
  final links = allocations.where((p) => p.invoiceId == invoice.id);
  final paid = links.where((p) => p.kind == 'payment').fold(0, (sum, p) => sum + p.allocatedMinor);
  final returned = links.where((p) => p.kind == 'refund').fold(0, (sum, p) => sum + p.allocatedMinor);
  if (invoice.kind == 'credit_note') return refund ? invoice.totalMinor - returned : 0;
  return refund ? paid - returned : invoice.totalMinor - paid + returned;
}

List<InvoiceSuggestion> rankInvoices(ReviewRow row, ReviewSnapshot snapshot) {
  final refund = row.transaction.direction == TxnDirection.credit;
  final merchant = normalizeBusinessMerchant(row.transaction.merchant ?? '');
  final suggestions = <InvoiceSuggestion>[];
  for (final invoice in snapshot.invoices) {
    if (invoice.arithmeticStatus != 'consistent' || invoice.currency != row.transaction.currency) continue;
    final available = invoiceAvailable(invoice, snapshot.allocations, refund: refund);
    if (available <= 0 || row.remaining <= 0) continue;
    final reasons = <String>[];
    var score = 0;
    if (available == row.remaining) {
      score += 70;
      reasons.add('Exact remaining amount');
    } else {
      score += 10;
      reasons.add(available < row.remaining ? 'Part of this payment' : 'Partial invoice payment');
    }
    final days = invoice.invoiceDate.difference(row.transaction.occurredAt).inDays.abs();
    if (days <= 7) {
      score += 20;
      reasons.add('Within 7 days');
    } else if (days <= 31) {
      score += 10;
      reasons.add('Within 31 days');
    }
    final vendor = normalizeBusinessMerchant(invoice.vendorName);
    final tokens = vendor.split(' ').where((w) => w.length > 2).toSet();
    if (merchant.isNotEmpty &&
        (merchant == vendor ||
            tokens.isNotEmpty && tokens.intersection(merchant.split(' ').toSet()).length / tokens.length >= 0.5)) {
      score += 30;
      reasons.add('Vendor name overlaps');
    }
    suggestions.add(InvoiceSuggestion(invoice, available, math.min(available, row.remaining), score, reasons));
  }
  suggestions.sort((a, b) {
    final score = b.score.compareTo(a.score);
    if (score != 0) return score;
    final days = a.invoice.invoiceDate
        .difference(row.transaction.occurredAt)
        .inDays
        .abs()
        .compareTo(b.invoice.invoiceDate.difference(row.transaction.occurredAt).inDays.abs());
    return days != 0 ? days : a.invoice.id.compareTo(b.invoice.id);
  });
  return suggestions;
}

class InvoiceDraft {
  const InvoiceDraft({
    required this.documentId,
    required this.vendor,
    required this.number,
    required this.date,
    required this.amounts,
    this.kind = 'invoice',
    this.supplierGstin,
    this.recipientGstin,
  });
  final int documentId;
  final String vendor, number, kind;
  final DateTime date;
  final InvoiceAmounts amounts;
  final String? supplierGstin, recipientGstin;
}

class ReconciliationService {
  const ReconciliationService(this.db, {required this.verifyDocument});
  final AppDatabase db;
  final Future<void> Function(Document) verifyDocument;

  Stream<ReviewSnapshot> watchMonth(DateTime month) => db
      .customSelect(
        'SELECT COUNT(*) AS n FROM transactions',
        readsFrom: {
          db.transactions,
          db.classifications,
          db.paymentAllocations,
          db.invoices,
          db.documents,
          db.businessRules,
        },
      )
      .watch()
      .asyncMap((_) => loadMonth(month));

  Future<ReviewSnapshot> loadMonth(DateTime month) => db.transaction(() async {
    final start = DateTime(month.year, month.month), end = DateTime(month.year, month.month + 1);
    final transactions =
        await (db.select(db.transactions)
              ..where(
                (t) =>
                    t.occurredAt.isBiggerOrEqualValue(start) &
                    t.occurredAt.isSmallerThanValue(end) &
                    t.currency.equals('INR') &
                    t.isTransfer.equals(false),
              )
              ..orderBy([(t) => OrderingTerm.desc(t.occurredAt), (t) => OrderingTerm.desc(t.id)]))
            .get();
    final classifications = {for (final c in await db.select(db.classifications).get()) c.transactionId: c};
    final invoices = await (db.select(db.invoices)..orderBy([(i) => OrderingTerm.desc(i.invoiceDate)])).get();
    final byId = {for (final invoice in invoices) invoice.id: invoice};
    final allocations = await db.select(db.paymentAllocations).get();
    final byTransaction = <int, List<PaymentAllocation>>{};
    for (final allocation in allocations) {
      byTransaction.putIfAbsent(allocation.transactionId, () => []).add(allocation);
    }
    return ReviewSnapshot(
      [for (final t in transactions) ReviewRow(t, classifications[t.id], byTransaction[t.id] ?? [], byId)],
      invoices,
      await (db.select(db.documents)..orderBy([(d) => OrderingTerm.desc(d.createdAt)])).get(),
      allocations,
      await db.select(db.businessRules).get(),
    );
  });

  Future<void> classify(int id, int bps, {bool remember = false, String? purpose}) =>
      db.classifyBusinessUse(id, bps, remember: remember, purpose: purpose);

  Future<int> applyRules(DateTime month) => db.transaction(() async {
    final snapshot = await loadMonth(month);
    var count = 0;
    for (final row in snapshot.rows.where((r) => !r.reviewed)) {
      if (await db.applyBusinessRule(row.transaction.id)) count++;
    }
    return count;
  });

  Future<void> removeRule(int id) async {
    await (db.delete(db.businessRules)..where((r) => r.id.equals(id))).go();
  }

  Future<int> saveInvoice(InvoiceDraft draft, {int? invoiceId}) => db.transaction(() async {
    final validation = validateInvoiceAmounts(draft.amounts);
    if (!validation.arithmeticConsistent) throw ReconciliationException(validation.issues.join(' '));
    if (draft.vendor.trim().isEmpty ||
        draft.number.trim().isEmpty ||
        draft.vendor.length > 180 ||
        draft.number.length > 100 ||
        draft.date.year < 1970 ||
        draft.date.year > 2100 ||
        !{'invoice', 'credit_note'}.contains(draft.kind) ||
        draft.amounts.total <= 0) {
      throw const ReconciliationException('Enter a vendor, invoice number, valid date and positive total.');
    }
    for (final gstin in [draft.supplierGstin, draft.recipientGstin]) {
      if (gstin != null && gstin.trim().isNotEmpty && !hasValidGstin(gstin)) {
        throw const ReconciliationException('Check the GSTIN format and checksum, or leave it blank.');
      }
    }
    final doc = await (db.select(db.documents)..where((d) => d.id.equals(draft.documentId))).getSingleOrNull();
    if (doc == null) throw const ReconciliationException('Attach the original invoice PDF first.');
    await verifyDocument(doc);
    final previous = invoiceId == null
        ? null
        : await (db.select(db.invoices)..where((i) => i.id.equals(invoiceId))).getSingleOrNull();
    if (invoiceId != null && previous == null) {
      throw const ReconciliationException('This invoice is no longer available.');
    }
    final duplicate = await (db.select(db.invoices)..where((i) => i.documentId.equals(draft.documentId))).get();
    if (duplicate.any((i) => i.id != invoiceId)) {
      throw const ReconciliationException('This PDF already has invoice details. Edit its existing invoice.');
    }
    if (invoiceId != null &&
        (await (db.select(db.invoiceLines)..where((l) => l.invoiceId.equals(invoiceId))).get()).isNotEmpty) {
      throw const ReconciliationException(
        'This invoice has itemised lines. Header editing is unavailable until those lines can be edited together.',
      );
    }
    final a = draft.amounts;
    final values = InvoicesCompanion(
      documentId: Value(draft.documentId),
      kind: Value(draft.kind),
      vendorName: Value(draft.vendor.trim()),
      invoiceNumber: Value(draft.number.trim()),
      invoiceDate: Value(DateTime(draft.date.year, draft.date.month, draft.date.day)),
      taxableMinor: Value(a.taxable),
      cgstMinor: Value(a.cgst),
      sgstMinor: Value(a.sgst),
      igstMinor: Value(a.igst),
      cessMinor: Value(a.cess),
      roundingMinor: Value(a.rounding),
      totalMinor: Value(a.total),
      supplierGstin: Value(_gstin(draft.supplierGstin)),
      recipientGstin: Value(_gstin(draft.recipientGstin)),
      arithmeticStatus: const Value('consistent'),
      gstEligibilityStatus: Value(previous?.gstEligibilityStatus ?? 'not_assessed'),
    );
    final int id;
    if (previous == null) {
      id = await db.into(db.invoices).insert(values);
    } else {
      id = previous.id;
      await (db.update(db.invoices)..where((i) => i.id.equals(id))).write(values);
    }
    await (db.update(
      db.documents,
    )..where((d) => d.id.equals(doc.id))).write(const DocumentsCompanion(extractionStatus: Value('needs_review')));
    final after = await (db.select(db.invoices)..where((i) => i.id.equals(id))).getSingle();
    await db
        .into(db.reviewEvents)
        .insert(
          ReviewEventsCompanion.insert(
            entityType: 'invoice',
            entityId: id,
            action: previous == null ? 'details_recorded' : 'details_edited',
            beforeJson: previous == null ? '{}' : jsonEncode(previous.toJson()),
            afterJson: jsonEncode(after.toJson()),
          ),
        );
    for (final link in await (db.select(db.paymentAllocations)..where((p) => p.invoiceId.equals(id))).get()) {
      await db.refreshEvidenceStatus(link.transactionId);
    }
    return id;
  });

  Future<void> link(int transactionId, int invoiceId, int minor) => db.transaction(() async {
    if (minor <= 0 || minor > maxLedgerMinor) {
      throw const ReconciliationException('Enter a positive amount in rupees and paise.');
    }
    final txn = await (db.select(db.transactions)..where((t) => t.id.equals(transactionId))).getSingle();
    final invoice = await (db.select(db.invoices)..where((i) => i.id.equals(invoiceId))).getSingle();
    if (txn.currency != 'INR' || txn.isTransfer || txn.businessUseBps == 0 || txn.status != TxnStatus.confirmed) {
      throw const ReconciliationException(
        'Review this INR payment as business and confirm its bank details before linking.',
      );
    }
    if (invoice.arithmeticStatus != 'consistent') {
      throw const ReconciliationException('Correct the invoice arithmetic before linking.');
    }
    final allocations = await db.select(db.paymentAllocations).get();
    final remaining =
        txn.amountMinor -
        allocations.where((p) => p.transactionId == transactionId).fold(0, (sum, p) => sum + p.allocatedMinor);
    final refund = txn.direction == TxnDirection.credit;
    final available = invoiceAvailable(invoice, allocations, refund: refund);
    if (minor > remaining || minor > available) {
      throw const ReconciliationException('That amount exceeds the payment or invoice balance. Nothing was linked.');
    }
    final doc = await (db.select(db.documents)..where((d) => d.id.equals(invoice.documentId))).getSingle();
    await verifyDocument(doc);
    final kind = refund ? 'refund' : 'payment';
    final existing = allocations
        .where((p) => p.transactionId == transactionId && p.invoiceId == invoiceId && p.kind == kind)
        .firstOrNull;
    if (existing == null) {
      await db
          .into(db.paymentAllocations)
          .insert(
            PaymentAllocationsCompanion.insert(
              transactionId: transactionId,
              invoiceId: invoiceId,
              kind: kind,
              allocatedMinor: minor,
            ),
          );
    } else {
      await (db.update(db.paymentAllocations)..where((p) => p.id.equals(existing.id))).write(
        PaymentAllocationsCompanion(
          allocatedMinor: Value(existing.allocatedMinor + minor),
          provenance: const Value('user'),
        ),
      );
    }
    await db.refreshEvidenceStatus(transactionId);
  });

  Future<void> unlink(int id) => db.transaction(() async {
    final link = await (db.select(db.paymentAllocations)..where((p) => p.id.equals(id))).getSingle();
    // Removing a payment with dependent refunds is rejected by the DB guard.
    await (db.delete(db.paymentAllocations)..where((p) => p.id.equals(id))).go();
    await db.refreshEvidenceStatus(link.transactionId);
  });

  Future<void> confirm(int id) => db.transaction(() async {
    final before = await (db.select(db.transactions)..where((t) => t.id.equals(id))).getSingle();
    await db.confirm(id);
    await db
        .into(db.reviewEvents)
        .insert(
          ReviewEventsCompanion.insert(
            entityType: 'transaction',
            entityId: id,
            action: 'bank_row_confirmed',
            beforeJson: jsonEncode({'status': before.status.name}),
            afterJson: '{"status":"confirmed"}',
          ),
        );
    if (before.businessUseBps > 0) await db.refreshEvidenceStatus(id);
  });
}

String? _gstin(String? value) => value == null || value.trim().isEmpty ? null : value.trim().toUpperCase();
