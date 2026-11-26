import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/money_minor.dart';
import '../../data/db/database.dart';
import '../../reconciliation/reconciliation_service.dart';
import 'invoice_editor.dart';
import 'reconciliation_providers.dart';
import 'reconciliation_widgets.dart';

class EvidenceSheet extends ConsumerStatefulWidget {
  const EvidenceSheet({super.key, required this.transactionId, required this.month});
  final int transactionId;
  final DateTime month;
  @override
  ConsumerState<EvidenceSheet> createState() => _EvidenceSheetState();
}

class _EvidenceSheetState extends ConsumerState<EvidenceSheet> {
  final _amount = TextEditingController();
  String _search = '';
  String? _error;
  int? _customInvoice;
  bool _busy = false;
  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
      if (mounted) setState(() => _customInvoice = null);
    } catch (e) {
      if (mounted) setState(() => _error = reviewError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _link(int invoiceId, int minor) =>
      _run(() => ref.read(reconciliationServiceProvider).link(widget.transactionId, invoiceId, minor));
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reconciliationMonthProvider(widget.month));
    final snapshot = state.value;
    final row = snapshot?.rows.where((r) => r.transaction.id == widget.transactionId).firstOrNull;
    final theme = Theme.of(context);
    if (row == null) {
      return sheetPadding(
        context,
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Payment evidence', style: theme.textTheme.titleLarge),
            const SizedBox(height: 20),
            if (state.isLoading)
              const LinearProgressIndicator()
            else
              reviewNotice(
                context,
                state.hasError
                    ? 'The payment could not be loaded. Close this sheet and retry.'
                    : 'This payment is no longer in this monthly view.',
              ),
          ],
        ),
      );
    }
    final suggestions = rankInvoices(row, snapshot!)
        .where(
          (s) => '${s.invoice.vendorName} ${s.invoice.invoiceNumber}'.toLowerCase().contains(_search.toLowerCase()),
        )
        .toList();
    final t = row.transaction;
    return sheetPadding(
      context,
      ListView(
        children: [
          Text(
            t.direction == TxnDirection.credit ? 'Match refund evidence' : 'Match invoice evidence',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(t.merchant ?? 'Payment', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            '${DateFormat('dd MMM yyyy').format(t.occurredAt)} · ${formatInrMinor(t.amountMinor)}',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          evidenceBadge(context, row.status),
          const SizedBox(height: 8),
          Text(
            '${formatInrMinor(row.allocated)} linked · ${formatInrMinor(row.remaining)} remaining',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Link evidence for the full payment. Your ${t.businessUseBps / 100}% business share and GST credit eligibility remain separate.',
            style: theme.textTheme.bodySmall,
          ),
          if (_error != null) reviewNotice(context, _error!, error: true),
          if (t.status == TxnStatus.needsReview) ...[
            reviewNotice(
              context,
              'This bank row was flagged during import. Check the amount, merchant and possible duplicates before confirming it.',
            ),
            OutlinedButton(
              onPressed: _busy ? null : () => _run(() => ref.read(reconciliationServiceProvider).confirm(t.id)),
              child: const Text('I checked this payment · confirm'),
            ),
          ],
          if (row.links.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text('Linked evidence', style: theme.textTheme.titleMedium),
            for (final link in row.links)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${row.invoices[link.invoiceId]?.vendorName ?? 'Invoice'} · ${row.invoices[link.invoiceId]?.invoiceNumber ?? link.invoiceId}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      children: [
                        Text(
                          '${formatInrMinor(link.allocatedMinor)} · ${link.kind}',
                          style: theme.textTheme.labelLarge,
                        ),
                        TextButton(
                          key: ValueKey('unlink-${link.id}'),
                          onPressed: _busy
                              ? null
                              : () => _run(() => ref.read(reconciliationServiceProvider).unlink(link.id)),
                          child: const Text('Unlink'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
          if (row.remaining > 0 && t.businessUseBps > 0) ...[
            const SizedBox(height: 24),
            Text('Suggested invoices', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Ranked by remaining amount, date and vendor name. Suggestions are not automatic matches.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 14),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Find vendor or invoice number',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
            if (suggestions.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  t.direction == TxnDirection.credit
                      ? 'No available refund evidence. Add a credit note, or link this refund to an invoice with a recorded payment.'
                      : 'No available invoice matches this view. Add details to an attached PDF or adjust the search.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            for (final suggestion in suggestions) _suggestion(context, suggestion, t.status == TxnStatus.confirmed),
          ],
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: _busy ? null : () => showLedgerSheet(context, const InvoiceLibrary()),
            icon: const Icon(Icons.description_outlined, size: 18),
            label: const Text('Add or edit invoice evidence'),
          ),
          const SizedBox(height: 16),
          Text(
            '“Evidence Matched” records a linked document and balanced amounts. It does not approve an expense or GST credit.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _busy ? null : () => Navigator.pop(context),
            child: Text(_busy ? 'Checking & saving…' : 'Done'),
          ),
        ],
      ),
    );
  }

  Widget _suggestion(BuildContext context, InvoiceSuggestion suggestion, bool confirmed) {
    final theme = Theme.of(context), invoice = suggestion.invoice;
    return Container(
      key: ValueKey('invoice-suggestion-${invoice.id}'),
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(invoice.vendorName, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            '${invoice.invoiceNumber} · ${DateFormat('dd MMM yyyy').format(invoice.invoiceDate)}${invoice.kind == 'credit_note' ? ' · Credit note' : ''}',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          Text(
            '${formatInrMinor(invoice.totalMinor)} total · ${formatInrMinor(suggestion.available)} available',
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: 6),
          Text(suggestion.reasons.join(' · '), style: theme.textTheme.bodySmall),
          const SizedBox(height: 6),
          Text('GST credit: ${invoice.gstEligibilityStatus.replaceAll('_', ' ')}', style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              FilledButton(
                key: ValueKey('link-invoice-${invoice.id}'),
                onPressed: _busy || !confirmed ? null : () => _link(invoice.id, suggestion.suggested),
                child: Text('Link ${formatInrMinor(suggestion.suggested)}'),
              ),
              TextButton(
                onPressed: _busy || !confirmed
                    ? null
                    : () => setState(() {
                        _customInvoice = _customInvoice == invoice.id ? null : invoice.id;
                        _amount.text =
                            '${suggestion.suggested ~/ 100}.${(suggestion.suggested % 100).toString().padLeft(2, '0')}';
                      }),
                child: const Text('Change amount'),
              ),
            ],
          ),
          if (_customInvoice == invoice.id) ...[
            const SizedBox(height: 14),
            TextField(
              key: const ValueKey('allocation-amount'),
              controller: _amount,
              enabled: !_busy,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Amount to link', prefixText: '₹ '),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _busy
                  ? null
                  : () => _run(() async {
                      final minor = parseInrMinor(_amount.text);
                      await ref.read(reconciliationServiceProvider).link(widget.transactionId, invoice.id, minor);
                    }),
              child: const Text('Save linked amount'),
            ),
          ],
        ],
      ),
    );
  }
}
