import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/money_minor.dart';
import '../../data/db/database.dart';
import '../../ingestion/statements/statement_csv.dart';
import '../../reconciliation/reconciliation_service.dart';
import '../../tax_checks/invoice_validation.dart';
import '../imports/statement_import_providers.dart';
import 'reconciliation_providers.dart';
import 'reconciliation_widgets.dart';

class InvoiceLibrary extends ConsumerStatefulWidget {
  const InvoiceLibrary({super.key});
  @override
  ConsumerState<InvoiceLibrary> createState() => _InvoiceLibraryState();
}

class _InvoiceLibraryState extends ConsumerState<InvoiceLibrary> {
  late final DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  bool _busy = false;
  String? _error;
  Future<void> _attach() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final file = await ref.read(pdfPickerProvider)();
      if (file == null) return;
      final vault = await ref.read(pdfVaultProvider.future);
      final document = await vault.addPdf(file.bytes, originalName: file.name);
      if (mounted) await showLedgerSheet(context, InvoiceEditor(document: document));
    } catch (e) {
      if (mounted) setState(() => _error = reviewError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reconciliationMonthProvider(_month));
    final snapshot = state.value;
    final invoices = {for (final invoice in snapshot?.invoices ?? <Invoice>[]) invoice.documentId: invoice};
    return sheetPadding(
      context,
      ListView(
        children: [
          Text('Invoice evidence', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text(
            'Record the exact figures printed on each PDF. Kankoo checks the arithmetic before offering a match.',
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _busy ? null : _attach,
            icon: const Icon(Icons.attach_file, size: 18),
            label: Text(_busy ? 'Attaching PDF…' : 'Attach invoice PDF'),
          ),
          if (_error != null) reviewNotice(context, _error!, error: true),
          reviewNotice(
            context,
            'PDFs stay encrypted on this device. Keep the originals: full attachment backup is not yet available.',
          ),
          if (state.isLoading) const LinearProgressIndicator(),
          if (state.hasError)
            reviewNotice(context, 'The invoice list could not be loaded. Close this sheet and retry.', error: true),
          if (snapshot != null && snapshot.documents.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('No invoices attached yet. Start with the original PDF.'),
            ),
          for (final document in snapshot?.documents ?? <Document>[])
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              leading: const Icon(Icons.picture_as_pdf_outlined),
              title: Text(document.originalName),
              subtitle: Text(
                invoices[document.id] == null
                    ? 'Details needed'
                    : '${invoices[document.id]!.vendorName} · ${formatInrMinor(invoices[document.id]!.totalMinor)}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: _busy
                  ? null
                  : () => showLedgerSheet(context, InvoiceEditor(document: document, invoice: invoices[document.id])),
            ),
        ],
      ),
    );
  }
}

class InvoiceEditor extends ConsumerStatefulWidget {
  const InvoiceEditor({super.key, required this.document, this.invoice});
  final Document document;
  final Invoice? invoice;
  @override
  ConsumerState<InvoiceEditor> createState() => _InvoiceEditorState();
}

class _InvoiceEditorState extends ConsumerState<InvoiceEditor> {
  final _fields = <String, TextEditingController>{};
  late String _kind;
  String? _error;
  bool _busy = false;
  @override
  void initState() {
    super.initState();
    final invoice = widget.invoice;
    String amount(int? value) => value == null
        ? ''
        : '${value < 0 ? '-' : ''}${value.abs() ~/ 100}.${(value.abs() % 100).toString().padLeft(2, '0')}';
    final values = {
      'vendor': invoice?.vendorName ?? '',
      'number': invoice?.invoiceNumber ?? '',
      'date': invoice == null
          ? ''
          : '${invoice.invoiceDate.year}-${invoice.invoiceDate.month.toString().padLeft(2, '0')}-${invoice.invoiceDate.day.toString().padLeft(2, '0')}',
      'taxable': amount(invoice?.taxableMinor),
      'total': amount(invoice?.totalMinor),
      'cgst': amount(invoice?.cgstMinor ?? 0),
      'sgst': amount(invoice?.sgstMinor ?? 0),
      'igst': amount(invoice?.igstMinor ?? 0),
      'cess': amount(invoice?.cessMinor ?? 0),
      'rounding': amount(invoice?.roundingMinor ?? 0),
      'supplier': invoice?.supplierGstin ?? '',
      'recipient': invoice?.recipientGstin ?? '',
    };
    for (final entry in values.entries) {
      _fields[entry.key] = TextEditingController(text: entry.value);
    }
    _kind = invoice?.kind ?? 'invoice';
  }

  @override
  void dispose() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
    super.dispose();
  }

  InvoiceAmounts get _amounts {
    int parse(String key, {bool signed = false}) =>
        parseInrMinor(_fields[key]!.text.trim().isEmpty ? '0' : _fields[key]!.text, signed: signed);
    return InvoiceAmounts(
      taxable: parse('taxable'),
      total: parse('total'),
      cgst: parse('cgst'),
      sgst: parse('sgst'),
      igst: parse('igst'),
      cess: parse('cess'),
      rounding: parse('rounding', signed: true),
    );
  }

  Future<void> _save() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final draft = InvoiceDraft(
        documentId: widget.document.id,
        vendor: _fields['vendor']!.text,
        number: _fields['number']!.text,
        date: parseStatementDate(_fields['date']!.text.trim(), 'yyyy-MM-dd'),
        kind: _kind,
        amounts: _amounts,
        supplierGstin: _fields['supplier']!.text,
        recipientGstin: _fields['recipient']!.text,
      );
      await ref.read(reconciliationServiceProvider).saveInvoice(draft, invoiceId: widget.invoice?.id);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) setState(() => _error = reviewError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _field(String key, String label, {bool money = false, bool signed = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextField(
      key: ValueKey('invoice-$key'),
      controller: _fields[key],
      enabled: !_busy,
      maxLength: key == 'vendor'
          ? 180
          : key == 'number'
          ? 100
          : null,
      keyboardType: money ? TextInputType.numberWithOptions(decimal: true, signed: signed) : TextInputType.text,
      decoration: InputDecoration(labelText: label, prefixText: money ? '₹ ' : null),
      onChanged: (_) => setState(() {}),
    ),
  );
  @override
  Widget build(BuildContext context) {
    String check;
    try {
      final amounts = _amounts;
      check = _fields['total']!.text.trim().isEmpty
          ? 'Enter the printed invoice total.'
          : validateInvoiceAmounts(amounts).arithmeticConsistent
          ? 'Arithmetic consistent · ${formatInrMinor(amounts.total)}'
          : 'Check the figures. Components add to ${formatInrMinor(amounts.calculatedTotal)}.';
    } on FormatException catch (e) {
      check = e.message;
    }
    return sheetPadding(
      context,
      ListView(
        children: [
          Text(
            widget.invoice == null ? 'Record invoice details' : 'Edit invoice details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(widget.document.originalName, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 20),
          _field('vendor', 'Vendor name'),
          _field('number', 'Invoice / credit note number'),
          _field('date', 'Invoice date · YYYY-MM-DD'),
          DropdownButtonFormField<String>(
            initialValue: _kind,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Document type'),
            items: const [
              DropdownMenuItem(value: 'invoice', child: Text('Invoice')),
              DropdownMenuItem(value: 'credit_note', child: Text('Credit note')),
            ],
            onChanged: _busy ? null : (v) => setState(() => _kind = v!),
          ),
          const SizedBox(height: 20),
          _field('taxable', 'Taxable / base value', money: true),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: const Text('Tax components & rounding'),
            children: [
              _field('cgst', 'CGST', money: true),
              _field('sgst', 'SGST', money: true),
              _field('igst', 'IGST', money: true),
              _field('cess', 'Cess', money: true),
              _field('rounding', 'Rounding adjustment', money: true, signed: true),
            ],
          ),
          const SizedBox(height: 14),
          _field('total', 'Printed total', money: true),
          reviewNotice(context, check),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: const Text('GSTIN details · optional'),
            children: [_field('supplier', 'Supplier GSTIN'), _field('recipient', 'Your business GSTIN')],
          ),
          const SizedBox(height: 14),
          Text(
            'GST credit eligibility: ${widget.invoice?.gstEligibilityStatus.replaceAll('_', ' ') ?? 'not assessed'}. Business share is recorded separately on the payment.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (_error != null) reviewNotice(context, _error!, error: true),
          const SizedBox(height: 20),
          FilledButton(
            key: const ValueKey('save-invoice'),
            onPressed: _busy ? null : _save,
            child: Text(_busy ? 'Checking PDF & saving…' : 'Save invoice details'),
          ),
        ],
      ),
    );
  }
}
