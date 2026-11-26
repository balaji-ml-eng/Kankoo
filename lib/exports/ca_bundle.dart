import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart' as hashes;
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show compute;

import '../core/currency.dart';
import '../data/db/database.dart';
import '../reconciliation/reconciliation_service.dart';
import '../tax_checks/invoice_validation.dart';

class CaExportException implements Exception {
  const CaExportException(this.message);
  final String message;
  @override
  String toString() => message;
}

class CaPreview {
  const CaPreview(this.payments, this.unreviewed, this.personal, this.foreign, this.transfers, this.pdfs);
  final int payments, unreviewed, personal, foreign, transfers, pdfs;
}

class CaBundle {
  const CaBundle(this.runId, this.fileName, this.bytes, this.manifestSha256, this.preview);
  final int runId;
  final String fileName, manifestSha256;
  final Uint8List bytes;
  final CaPreview preview;
}

class _Selection {
  _Selection(
    this.payments,
    this.related,
    this.invoices,
    this.documents,
    this.links,
    this.classifications,
    this.lines,
    this.sources,
    this.jobs,
    this.audit,
  );
  final List<Transaction> payments, related;
  final List<Invoice> invoices;
  final List<Document> documents;
  final List<PaymentAllocation> links;
  final List<Classification> classifications;
  final List<InvoiceLine> lines;
  final List<SourceEvent> sources;
  final List<ImportJob> jobs;
  final List<ReviewEvent> audit;
  CaPreview get preview {
    final reviewed = classifications.map((c) => c.transactionId).toSet();
    return CaPreview(
      payments.length,
      payments.where((t) => !reviewed.contains(t.id) && !t.isTransfer).length,
      payments.where((t) => reviewed.contains(t.id) && t.businessUseBps == 0 && !t.isTransfer).length,
      payments.where((t) => t.currency != 'INR').length,
      payments.where((t) => t.isTransfer).length,
      documents.length,
    );
  }
}

/// A consistent SQL snapshot, authenticated original PDFs and immutable export
/// receipts. No plaintext output is written inside the app's private storage.
class CaExportService {
  CaExportService(this.db, {required this.readPdf, DateTime Function()? now}) : now = now ?? DateTime.now;
  final AppDatabase db;
  final Future<Uint8List> Function(Document) readPdf;
  final DateTime Function() now;
  static const maxBundleBytes = 100 * 1024 * 1024;
  static const maxRows = 50000;

  Future<List<T>> _ids<T>(Iterable<int> ids, Future<List<T>> Function(List<int>) query) async {
    final sorted = ids.toSet().toList()..sort();
    final result = <T>[];
    for (var i = 0; i < sorted.length; i += 100) {
      result.addAll(await query(sorted.sublist(i, (i + 100).clamp(0, sorted.length))));
    }
    return result;
  }

  Future<_Selection> _load(DateTime month) async {
    final start = DateTime(month.year, month.month), end = DateTime(month.year, month.month + 1);
    final payments =
        await (db.select(db.transactions)
              ..where((t) => t.occurredAt.isBiggerOrEqualValue(start) & t.occurredAt.isSmallerThanValue(end))
              ..orderBy([(t) => OrderingTerm.asc(t.occurredAt), (t) => OrderingTerm.asc(t.id)])
              ..limit(maxRows + 1))
            .get();
    if (payments.length > maxRows) {
      throw const CaExportException('This month exceeds the 50,000-payment export limit. No bundle was recorded.');
    }
    final monthlyIds = payments.map((t) => t.id).toSet();
    final directLinks = await _ids(
      monthlyIds,
      (ids) => (db.select(db.paymentAllocations)..where((p) => p.transactionId.isIn(ids))).get(),
    );
    final invoices = <int, Invoice>{
      for (final i in await (db.select(
        db.invoices,
      )..where((i) => i.invoiceDate.isBiggerOrEqualValue(start) & i.invoiceDate.isSmallerThanValue(end))).get())
        i.id: i,
    };
    for (final i in await _ids(
      directLinks.map((p) => p.invoiceId),
      (ids) => (db.select(db.invoices)..where((i) => i.id.isIn(ids))).get(),
    )) {
      invoices[i.id] = i;
    }
    final links = await _ids(
      invoices.keys,
      (ids) => (db.select(db.paymentAllocations)..where((p) => p.invoiceId.isIn(ids))).get(),
    );
    final related = await _ids(
      links.map((p) => p.transactionId).where((id) => !monthlyIds.contains(id)),
      (ids) => (db.select(db.transactions)..where((t) => t.id.isIn(ids))).get(),
    );
    final paymentIds = {...monthlyIds, ...related.map((t) => t.id)};
    final documents = <int, Document>{
      for (final d in await _ids(
        invoices.values.map((i) => i.documentId),
        (ids) => (db.select(db.documents)..where((d) => d.id.isIn(ids))).get(),
      ))
        d.id: d,
    };
    // PDFs attached this month without invoice details still need CA review.
    final assigned = await (db.selectOnly(db.invoices)..addColumns([db.invoices.documentId])).get();
    final assignedIds = assigned.map((r) => r.read(db.invoices.documentId)).toSet();
    for (final d in await (db.select(
      db.documents,
    )..where((d) => d.createdAt.isBiggerOrEqualValue(start) & d.createdAt.isSmallerThanValue(end))).get()) {
      if (!assignedIds.contains(d.id)) documents[d.id] = d;
    }
    final classifications = await _ids(
      paymentIds,
      (ids) => (db.select(db.classifications)..where((c) => c.transactionId.isIn(ids))).get(),
    );
    final lines = await _ids(
      invoices.keys,
      (ids) => (db.select(db.invoiceLines)..where((l) => l.invoiceId.isIn(ids))).get(),
    );
    final sources = await _ids(
      paymentIds,
      (ids) => (db.select(db.sourceEvents)..where((s) => s.transactionId.isIn(ids))).get(),
    );
    final jobs = await _ids(
      sources.map((s) => s.importJobId).whereType<int>(),
      (ids) => (db.select(db.importJobs)..where((j) => j.id.isIn(ids))).get(),
    );
    final audit = <int, ReviewEvent>{};
    Future<void> events(Iterable<int> ids, String type, String foreignKey) async {
      for (final event in await _ids(
        ids,
        (chunk) =>
            (db.select(db.reviewEvents)..where(
                  (e) =>
                      (e.entityType.equals(type) & e.entityId.isIn(chunk)) |
                      CustomExpression<int>("json_extract(before_json, '\$.$foreignKey')").isIn(chunk) |
                      CustomExpression<int>("json_extract(after_json, '\$.$foreignKey')").isIn(chunk),
                ))
                .get(),
      )) {
        audit[event.id] = event;
      }
    }

    await events(paymentIds, 'transaction', 'transaction_id');
    await events(invoices.keys, 'invoice', 'invoice_id');
    await events(documents.keys, 'document', 'document_id');
    // Retain month edits even when their former parent row has been deleted.
    for (final event in await (db.select(
      db.reviewEvents,
    )..where((e) => e.timestamp.isBiggerOrEqualValue(start) & e.timestamp.isSmallerThanValue(end))).get()) {
      audit[event.id] = event;
    }
    final merchants = [
      ...payments,
      ...related,
    ].map((t) => normalizeBusinessMerchant(t.merchant ?? '')).where((m) => m.isNotEmpty).toSet().toList();
    for (var i = 0; i < merchants.length; i += 100) {
      final chunk = merchants.sublist(i, (i + 100).clamp(0, merchants.length));
      for (final e
          in await (db.select(db.reviewEvents)..where(
                (e) =>
                    e.entityType.equals('business_rules') &
                    (const CustomExpression<String>("json_extract(before_json, '\$.merchant_pattern')").isIn(chunk) |
                        const CustomExpression<String>("json_extract(after_json, '\$.merchant_pattern')").isIn(chunk)),
              ))
              .get()) {
        audit[e.id] = e;
      }
    }
    return _Selection(
      payments,
      related..sort((a, b) => a.id.compareTo(b.id)),
      invoices.values.toList()..sort((a, b) => a.id.compareTo(b.id)),
      documents.values.toList()..sort((a, b) => a.id.compareTo(b.id)),
      links..sort((a, b) => a.id.compareTo(b.id)),
      classifications,
      lines..sort(
        (a, b) =>
            a.invoiceId == b.invoiceId ? a.lineNumber.compareTo(b.lineNumber) : a.invoiceId.compareTo(b.invoiceId),
      ),
      sources..sort((a, b) => a.id.compareTo(b.id)),
      jobs..sort((a, b) => a.id.compareTo(b.id)),
      audit.values.toList()..sort((a, b) => a.id.compareTo(b.id)),
    );
  }

  Future<CaPreview> preview(DateTime month) => db.transaction(() async => (await _load(month)).preview);

  Future<CaBundle> create(DateTime month) => db.transaction(() async {
    final selected = await _load(month), preview = selected.preview;
    if (preview.payments == 0 && preview.pdfs == 0) {
      throw const CaExportException('There are no payments or invoice documents for this month.');
    }
    await db.validateEvidenceIntegrity();
    final stamp = now().toUtc(), start = DateTime(month.year, month.month), end = DateTime(month.year, month.month + 1);
    final lastId = db.exportRuns.id.max();
    final runId = ((await (db.selectOnly(db.exportRuns)..addColumns([lastId])).getSingle()).read(lastId) ?? 0) + 1;
    final files = <String, Uint8List>{};
    var size = 0;
    void add(String path, List<int> bytes) {
      size += bytes.length;
      if (size > maxBundleBytes) {
        throw const CaExportException('This bundle exceeds the 100 MB uncompressed limit. No export was recorded.');
      }
      files[path] = Uint8List.fromList(bytes);
    }

    void csv(String path, List<List<Object?>> rows) => add(path, caCsv(rows));
    final names = <int, String>{}, checks = <int, String>{};
    final linesByInvoice = <int, List<InvoiceLine>>{};
    for (final line in selected.lines) {
      linesByInvoice.putIfAbsent(line.invoiceId, () => []).add(line);
    }
    final monthlyIds = selected.payments.map((t) => t.id).toSet();
    final invoiceForDocument = <int, Invoice>{};
    for (final i in selected.invoices) {
      if (invoiceForDocument.containsKey(i.documentId)) {
        throw const CaExportException(
          'Multiple invoices use the same PDF. Review the invoice library before exporting.',
        );
      }
      invoiceForDocument[i.documentId] = i;
      final validation = validateInvoiceAmounts(
        _amounts(i),
        lines: (linesByInvoice[i.id] ?? <InvoiceLine>[]).map(_lineAmounts).toList(),
      );
      checks[i.id] = validation.arithmeticConsistent ? 'consistent' : 'mismatch';
      if (selected.links.any((p) => p.invoiceId == i.id) &&
          (i.arithmeticStatus != 'consistent' || !validation.arithmeticConsistent)) {
        throw CaExportException('Linked invoice ${i.id} has inconsistent amounts. Review it before exporting.');
      }
    }
    for (final d in selected.documents) {
      if (size + d.byteLength > maxBundleBytes) {
        throw const CaExportException('Invoice PDFs exceed the 100 MB bundle limit. No export was recorded.');
      }
      final bytes = await readPdf(d);
      if (bytes.length != d.byteLength || _hash(bytes) != d.sha256) {
        throw CaExportException('Invoice PDF ${d.id} failed its integrity check. No export was recorded.');
      }
      final invoice = invoiceForDocument[d.id];
      final filename = invoice == null
          ? 'unassigned_${d.id}_${d.sha256.substring(0, 12)}.pdf'
          : '${_date(invoice.invoiceDate)}_${_safe(invoice.vendorName)}_${_safe(invoice.invoiceNumber)}_${d.id}_${d.sha256.substring(0, 12)}.pdf';
      names[d.id] = 'invoices/$filename';
      add(names[d.id]!, bytes);
    }
    final categories = {for (final c in await db.allCategories()) c.id: c.name};
    final accounts = {for (final a in await db.allAccounts()) a.id: a};
    final classifications = {for (final c in selected.classifications) c.transactionId: c};
    final linksByTxn = <int, List<PaymentAllocation>>{};
    for (final p in selected.links) {
      linksByTxn.putIfAbsent(p.transactionId, () => []).add(p);
    }
    final byInvoice = {for (final i in selected.invoices) i.id: i};
    final header = <Object?>[
      'payment_id',
      'date_local',
      'occurred_at_utc',
      'currency',
      'amount',
      'amount_minor',
      'direction',
      'merchant',
      'category',
      'account',
      'account_last4',
      'mode',
      'reference',
      'note',
      'business_use_bps',
      'business_amount',
      'business_minor',
      'review_status',
      'business_purpose',
      'provenance',
      'gst_eligibility',
      'self_transfer',
      'invoice_ids',
      'pdf_paths',
      'bank_status',
      'possible_duplicate_of',
    ];
    List<Object?> row(Transaction t) {
      final c = classifications[t.id];
      if (c != null && c.businessUseBps != t.businessUseBps) {
        throw CaExportException(
          'Payment ${t.id} has conflicting business classifications. Review it before exporting.',
        );
      }
      final links = linksByTxn[t.id] ?? <PaymentAllocation>[];
      final review = ReviewRow(t, c, links, byInvoice);
      return [
        t.id,
        _date(t.occurredAt),
        t.occurredAt.toUtc().toIso8601String(),
        t.currency,
        _plain(t.amountMinor, t.currency),
        t.amountMinor,
        t.direction.name,
        t.merchant,
        categories[t.categoryId],
        accounts[t.accountId]?.name,
        accounts[t.accountId]?.last4,
        t.mode.name,
        t.reference,
        t.note,
        t.businessUseBps,
        _plain(review.businessShare, t.currency),
        review.businessShare,
        t.isTransfer
            ? 'Self-transfer'
            : t.currency != 'INR'
            ? 'Foreign currency: review separately; ${review.status}'
            : review.status,
        c?.businessPurpose,
        c?.provenance,
        c?.gstEligibilityStatus ?? 'not_assessed',
        t.isTransfer,
        links.map((p) => p.invoiceId).toSet().join(';'),
        links.map((p) => names[byInvoice[p.invoiceId]?.documentId]).whereType<String>().toSet().join(';'),
        t.status.name,
        t.duplicateOfId,
      ];
    }

    csv('ledger.csv', [header, ...selected.payments.map(row)]);
    csv('related_payments.csv', [header, ...selected.related.map(row)]);
    final totals = <String, List<BigInt>>{};
    for (final t in selected.payments.where((t) => !t.isTransfer)) {
      final values = totals.putIfAbsent(t.currency, () => List.filled(4, BigInt.zero));
      final side = t.direction == TxnDirection.debit ? 0 : 1;
      values[side] += BigInt.from(t.amountMinor);
      if (classifications.containsKey(t.id) && t.status == TxnStatus.confirmed && t.duplicateOfId == null) {
        values[side + 2] += BigInt.from(businessMinor(t.amountMinor, t.businessUseBps));
      }
    }
    csv('summary.csv', [
      [
        'currency',
        'gross_debits',
        'gross_credits',
        'net_outflow',
        'reviewed_business_debits',
        'reviewed_business_credits',
        'net_reviewed_business_outflow',
        'gross_debits_minor',
        'gross_credits_minor',
        'business_debits_minor',
        'business_credits_minor',
      ],
      for (final currency in totals.keys.toList()..sort())
        [
          currency,
          ...[
            totals[currency]![0],
            totals[currency]![1],
            totals[currency]![0] - totals[currency]![1],
            totals[currency]![2],
            totals[currency]![3],
            totals[currency]![2] - totals[currency]![3],
          ].map((n) => _plainBig(n, currency)),
          ...totals[currency]!,
        ],
    ]);
    csv('invoices.csv', [
      [
        'invoice_id',
        'kind',
        'invoice_date',
        'vendor',
        'invoice_number',
        'supplier_gstin',
        'recipient_gstin',
        'currency',
        'taxable',
        'cgst',
        'sgst',
        'igst',
        'cess',
        'rounding',
        'total',
        'total_minor',
        'arithmetic_at_export',
        'gst_eligibility',
        'pdf_path',
      ],
      for (final i in selected.invoices)
        [
          i.id,
          i.kind,
          _date(i.invoiceDate),
          i.vendorName,
          i.invoiceNumber,
          i.supplierGstin,
          i.recipientGstin,
          i.currency,
          ...[
            i.taxableMinor,
            i.cgstMinor,
            i.sgstMinor,
            i.igstMinor,
            i.cessMinor,
            i.roundingMinor,
            i.totalMinor,
          ].map((n) => _plain(n, i.currency)),
          i.totalMinor,
          checks[i.id],
          i.gstEligibilityStatus,
          names[i.documentId],
        ],
    ]);
    csv('invoice_lines.csv', [
      [
        'invoice_id',
        'line_number',
        'description',
        'hsn_sac',
        'tax_rate_bps',
        'taxable_minor',
        'cgst_minor',
        'sgst_minor',
        'igst_minor',
        'cess_minor',
        'total_minor',
      ],
      for (final l in selected.lines)
        [
          l.invoiceId,
          l.lineNumber,
          l.description,
          l.hsnSac,
          l.taxRateBps,
          l.taxableMinor,
          l.cgstMinor,
          l.sgstMinor,
          l.igstMinor,
          l.cessMinor,
          l.totalMinor,
        ],
    ]);
    csv('allocations.csv', [
      [
        'allocation_id',
        'payment_id',
        'invoice_id',
        'kind',
        'currency',
        'allocated',
        'allocated_minor',
        'provenance',
        'created_at_utc',
        'outside_payment_month',
      ],
      for (final p in selected.links)
        [
          p.id,
          p.transactionId,
          p.invoiceId,
          p.kind,
          p.currency,
          _plain(p.allocatedMinor, p.currency),
          p.allocatedMinor,
          p.provenance,
          p.createdAt.toUtc().toIso8601String(),
          !monthlyIds.contains(p.transactionId),
        ],
    ]);
    csv('documents.csv', [
      ['document_id', 'original_filename', 'pdf_path', 'sha256', 'bytes', 'status'],
      for (final d in selected.documents)
        [
          d.id,
          d.originalName,
          names[d.id],
          d.sha256,
          d.byteLength,
          invoiceForDocument.containsKey(d.id) ? 'Invoice recorded manually' : 'Needs invoice details',
        ],
    ]);
    csv('source_events.csv', [
      [
        'source_event_id',
        'payment_id',
        'source',
        'source_account_id',
        'external_id',
        'content_sha256',
        'import_job_id',
        'received_at_utc',
      ],
      for (final s in selected.sources)
        [
          s.id,
          s.transactionId,
          s.source,
          s.sourceAccountId,
          s.externalId,
          s.contentHash,
          s.importJobId,
          s.receivedAt.toUtc().toIso8601String(),
        ],
    ]);
    final notificationSources = <int, RawMessage>{
      for (final r in await _ids(
        [...selected.payments, ...selected.related].map((t) => t.id),
        (ids) => (db.select(
          db.rawMessages,
        )..where((r) => r.source.equalsValue(SourceKind.notification) & r.transactionId.isIn(ids))).get(),
      ))
        r.id: r,
      for (final r
          in await (db.select(db.rawMessages)..where(
                (r) =>
                    r.source.equalsValue(SourceKind.notification) &
                    r.receivedAt.isBiggerOrEqualValue(start) &
                    r.receivedAt.isSmallerThanValue(end) &
                    r.transactionId.isNull(),
              ))
              .get())
        r.id: r,
    };
    csv('notification_sources.csv', [
      ['raw_id', 'payment_id', 'package', 'external_id', 'received_at_utc', 'parse_status', 'text_sha256'],
      for (final r in notificationSources.values.toList()..sort((a, b) => a.id.compareTo(b.id)))
        [
          r.id,
          r.transactionId,
          r.sender,
          r.externalId,
          r.receivedAt.toUtc().toIso8601String(),
          r.parseStatus.name,
          _hash(utf8.encode(r.body)),
        ],
    ]);
    csv('statement_imports.csv', [
      [
        'import_job_id',
        'file_name',
        'file_sha256',
        'source_account_id',
        'parser_version',
        'currency',
        'opening_minor',
        'credits_minor',
        'debits_minor',
        'closing_minor',
        'rows',
        'added',
        'matched',
        'skipped',
        'status',
        'mapping_json',
      ],
      for (final j in selected.jobs)
        [
          j.id,
          j.fileName,
          j.fileHash,
          j.sourceAccountId,
          j.parserVersion,
          j.currency,
          j.openingMinor,
          j.creditMinor,
          j.debitMinor,
          j.closingMinor,
          j.rowCount,
          j.addedCount,
          j.matchedCount,
          j.skippedCount,
          j.status,
          j.mappingJson,
        ],
    ]);
    csv('audit.csv', [
      ['event_id', 'timestamp_utc', 'entity_type', 'entity_id', 'action', 'provenance', 'before_json', 'after_json'],
      for (final e in selected.audit)
        [
          e.id,
          e.timestamp.toUtc().toIso8601String(),
          e.entityType,
          e.entityId,
          e.action,
          e.provenance,
          e.beforeJson,
          e.afterJson,
        ],
    ]);
    final records = <({String type, int id, Map<String, Object?> data})>[
      for (final t in [...selected.payments, ...selected.related])
        (
          type: 'transaction',
          id: t.id,
          data: {
            'transaction': t.toJson(),
            'classification': classifications[t.id]?.toJson(),
            'allocations': [for (final p in linksByTxn[t.id] ?? <PaymentAllocation>[]) p.toJson()],
          },
        ),
      for (final i in selected.invoices)
        (
          type: 'invoice',
          id: i.id,
          data: {
            'invoice': i.toJson(),
            'lines': [for (final l in linesByInvoice[i.id] ?? <InvoiceLine>[]) l.toJson()],
            'pdf_path': names[i.documentId],
            'arithmetic_at_export': checks[i.id],
          },
        ),
      for (final d in selected.documents)
        (
          type: 'document',
          id: d.id,
          data: {
            'id': d.id,
            'sha256': d.sha256,
            'original_name': d.originalName,
            'bytes': d.byteLength,
            'pdf_path': names[d.id],
          },
        ),
    ];
    final snapshots = [
      for (final r in records)
        {
          'entity_type': r.type,
          'entity_id': r.id,
          'content_sha256': _hash(utf8.encode(canonicalJson(r.data))),
          'snapshot': r.data,
        },
    ];
    add('records.json', utf8.encode(canonicalJson(snapshots)));
    add(
      'README.txt',
      utf8.encode(
        'Kankoo monthly CA handoff\nPeriod: ${_date(start)} to ${_date(end)} (end exclusive, device-local calendar).\n'
        'ledger.csv includes ALL payments in this month, including personal, unreviewed, foreign and self-transfers.\n'
        'Summary gross flows include unreviewed and possible-duplicate rows, excluding only self-transfers; reconcile these before relying on totals. Reviewed business flows also exclude unconfirmed payments and possible duplicates.\n'
        'related_payments.csv contains ONLY out-of-month payments needed to explain included invoice allocations; do not count them as this month spending.\n'
        'Invoices include this month invoice dates, invoices linked to month payments, and unassigned PDFs attached this month.\n'
        'Every included PDF was decrypted, authenticated and SHA-256 verified at export. No original document was changed.\n'
        'Evidence Matched describes links, not tax approval. Business use and GST eligibility remain separate; GSTIN checks are structural only.\n'
        'CSV files are UTF-8 with BOM, quoted, and formula-like text is prefixed with an apostrophe. Import identifier/reference columns as text in Excel. '
        'Amounts have exact minor-unit columns; use records.json for lossless values beyond spreadsheet numeric precision.\n'
        'The SHA-256 manifest covers every payload file except itself; its digest is recorded in the app export history. It detects changes, not who supplied the data.\n'
        'Audit covers edits made this month plus history of the included records and matching merchant rules. Deleted rows may be referenced only in audit snapshots.\n'
        'This ZIP contains readable financial data and PDFs. Share securely. It is a CA handoff, not a complete restorable app backup.\n',
      ),
    );
    final manifest = canonicalJson({
      'format': 'kankoo-ca-bundle',
      'format_version': 1,
      'export_run_id': runId,
      'created_at_utc': stamp.toIso8601String(),
      'period_start_utc': start.toUtc().toIso8601String(),
      'period_end_utc': end.toUtc().toIso8601String(),
      'calendar': 'device-local',
      'start_offset_minutes': start.timeZoneOffset.inMinutes,
      'end_offset_minutes': end.timeZoneOffset.inMinutes,
      'payments': preview.payments,
      'related_payments': selected.related.length,
      'invoices': selected.invoices.length,
      'pdfs': preview.pdfs,
      'unreviewed': preview.unreviewed,
      'personal': preview.personal,
      'foreign_currency': preview.foreign,
      'self_transfers': preview.transfers,
      'files': [
        for (final path in files.keys.toList()..sort())
          {'path': path, 'bytes': files[path]!.length, 'sha256': _hash(files[path]!)},
      ],
    });
    final manifestHash = _hash(utf8.encode(manifest));
    add('manifest.json', utf8.encode(manifest));
    final bytes = await compute(_zipFiles, files);
    await db
        .into(db.exportRuns)
        .insert(
          ExportRunsCompanion.insert(
            id: Value(runId),
            periodStart: start,
            periodEnd: end,
            formatVersion: 1,
            includedCount: preview.payments,
            manifestSha256: manifestHash,
            createdAt: Value(stamp),
          ),
        );
    await db.batch(
      (batch) => batch.insertAll(db.exportItems, [
        for (final r in records)
          ExportItemsCompanion.insert(
            exportRunId: runId,
            entityType: r.type,
            entityId: r.id,
            snapshotJson: canonicalJson(r.data),
            contentHash: _hash(utf8.encode(canonicalJson(r.data))),
          ),
      ]),
    );
    return CaBundle(
      runId,
      'kankoo-ca-${start.year}-${start.month.toString().padLeft(2, '0')}-export-$runId.zip',
      bytes,
      manifestHash,
      preview,
    );
  });
}

InvoiceAmounts _amounts(Invoice i) => InvoiceAmounts(
  taxable: i.taxableMinor,
  total: i.totalMinor,
  cgst: i.cgstMinor,
  sgst: i.sgstMinor,
  igst: i.igstMinor,
  cess: i.cessMinor,
  rounding: i.roundingMinor,
);
InvoiceAmounts _lineAmounts(InvoiceLine l) => InvoiceAmounts(
  taxable: l.taxableMinor,
  total: l.totalMinor,
  cgst: l.cgstMinor,
  sgst: l.sgstMinor,
  igst: l.igstMinor,
  cess: l.cessMinor,
);
String _hash(List<int> bytes) => hashes.sha256.convert(bytes).toString();
String _plain(int value, String currency) => _plainBig(BigInt.from(value), currency);
String _plainBig(BigInt value, String currency) {
  final digits = currencyDigits(currency), scale = BigInt.from(10).pow(currencyDigits(currency));
  final absolute = value.abs(), whole = absolute ~/ scale, fraction = absolute % scale;
  return '${value.isNegative ? '-' : ''}$whole${digits == 0 ? '' : '.${fraction.toString().padLeft(digits, '0')}'}';
}

String _date(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
String _safe(String value) {
  final text = value.replaceAll(RegExp('[^a-zA-Z0-9_-]+'), '_').replaceAll(RegExp('_+'), '_');
  return (text.isEmpty ? 'document' : text).substring(0, text.isEmpty ? 8 : text.length.clamp(0, 40));
}

String canonicalJson(Object? value) {
  Object? sort(Object? v) => v is Map
      ? {for (final key in v.keys.map((k) => k.toString()).toList()..sort()) key: sort(v[key])}
      : v is List
      ? v.map(sort).toList()
      : v;
  return jsonEncode(sort(value));
}

List<int> caCsv(List<List<Object?>> rows) {
  String cell(Object? value) {
    var text = value?.toString() ?? '';
    if (value is String &&
        !RegExp(r'^-?\d+(?:\.\d+)?$').hasMatch(text) &&
        RegExp(r'^[\s\x00-\x1f]*[=+@-]').hasMatch(text)) {
      text = "'$text";
    }
    return '"${text.replaceAll('"', '""')}"';
  }

  return utf8.encode('\ufeff${rows.map((r) => r.map(cell).join(',')).join('\r\n')}\r\n');
}

Uint8List _zipFiles(Map<String, Uint8List> files) {
  final archive = Archive();
  for (final path in files.keys.toList()..sort()) {
    archive.addFile(ArchiveFile.bytes(path, files[path]!));
  }
  return ZipEncoder().encodeBytes(archive);
}
