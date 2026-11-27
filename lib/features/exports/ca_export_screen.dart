import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/security/app_lock.dart';
import '../../documents/vault/pdf_vault.dart';
import '../../exports/ca_bundle.dart';
import '../../ui/ledger_theme.dart';
import '../../ui/ledger_brand.dart';
import '../../ui/widgets.dart';
import '../reconciliation/reconciliation_widgets.dart';
import 'ca_export_providers.dart';

class CaExportScreen extends ConsumerStatefulWidget {
  const CaExportScreen({super.key, required this.month});
  final DateTime month;
  @override
  ConsumerState<CaExportScreen> createState() => _CaExportScreenState();
}

class _CaExportScreenState extends ConsumerState<CaExportScreen> {
  bool _busy = false;
  String? _error, _result;
  Future<void> _save() async {
    setState(() {
      _busy = true;
      _error = null;
      _result = null;
    });
    try {
      final bundle = await ref.read(caExportServiceProvider).create(widget.month);
      if (!mounted) return;
      if (ref.read(appLockProvider).locked || WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
        throw const CaExportException(
          'Open and unlock Kankoo before saving the bundle. The generated snapshot is retained in export history.',
        );
      }
      final saved = await ref.read(caBundleSaverProvider)(bundle.fileName, bundle.bytes);
      if (mounted) {
        setState(
          () => _result = saved
              ? 'Saved ${bundle.fileName}. ${bundle.preview.pdfs} original PDFs verified.'
              : 'Save cancelled. Generated snapshot #${bundle.runId} is recorded; no saved file is claimed.',
        );
      }
    } catch (error) {
      final message = switch (error) {
        CaExportException(:final message) => message,
        VaultException(:final message) => message,
        _ => 'The bundle could not be completed. Your ledger, PDF files and keys were kept. Retry after checking access to the invoice vault.',
      };
      if (mounted) setState(() => _error = message);
    } finally {
      if (mounted) {
        setState(() => _busy = false);
        ref.invalidate(caExportPreviewProvider(widget.month));
      }
    }
  }

  @override
  Widget build(BuildContext context) => Theme(
    data: ledgerTheme(Theme.of(context).brightness),
    child: Builder(
      builder: (context) {
        final theme = Theme.of(context), preview = ref.watch(caExportPreviewProvider(widget.month));
        final history = ref.watch(caExportHistoryProvider(widget.month));
        return Scaffold(
          appBar: AppBar(title: const Text('CA export')),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                  children: [
                    const LedgerEyebrow('Monthly handoff'),
                    const SizedBox(height: 10),
                    Text(DateFormat('MMMM yyyy').format(widget.month), style: theme.textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Your ledger and original evidence, together.',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 24),
                    preview.when(
                      data: (p) => AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _metric(context, 'Monthly payments', p.payments)),
                                const SizedBox(width: 20),
                                Expanded(child: _metric(context, 'Original PDFs', p.pdfs)),
                              ],
                            ),
                            const SizedBox(height: 18),
                            const Divider(height: 1),
                            ExpansionTile(
                              title: const Text('Review included rows'),
                              subtitle: Text('${p.unreviewed} unreviewed · ${p.personal} personal'),
                              children: [
                                _line(context, 'Foreign-currency rows', '${p.foreign}'),
                                _line(context, 'Self-transfers', '${p.transfers}'),
                                const Text(
                                  'All month payments are included. Related payments from other months appear separately to explain invoice balances.',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      loading: () => const LinearProgressIndicator(),
                      error: (_, _) => reviewNotice(
                        context,
                        'The monthly preview could not be loaded. Retry without changing your ledger.',
                        review: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    reviewNotice(
                      context,
                      'Contains readable financial records and PDFs. Save securely. This is a CA handoff, not a complete restorable app backup.',
                    ),
                    if (_error != null) reviewNotice(context, _error!, error: true),
                    if (_result != null) reviewNotice(context, _result!),
                    FilledButton.icon(
                      onPressed:
                          _busy || !preview.hasValue || (preview.value!.payments == 0 && preview.value!.pdfs == 0)
                          ? null
                          : _save,
                      icon: _busy
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.save_alt, size: 19),
                      label: Text(_busy ? 'Verifying PDFs and preparing files…' : 'Save CA bundle (ZIP)'),
                    ),
                    TextButton(
                      onPressed: _busy ? null : () => ref.invalidate(caExportPreviewProvider(widget.month)),
                      child: const Text('Refresh preview'),
                    ),
                    const SizedBox(height: 12),
                    const ExpansionTile(
                      title: Text('Inside the ZIP'),
                      subtitle: Text('CSV ledgers, original PDFs and an audit trail'),
                      children: [
                        Text(
                          'Excel-compatible CSV ledgers, currency summaries, invoice details, payment/refund allocations, source references, audit history and a SHA-256 manifest. Original PDFs are renamed and linked by filename.',
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Evidence Matched is not tax approval. Business use and GST eligibility stay separate for your CA to review.',
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    const LedgerEyebrow('Generated snapshots'),
                    const SizedBox(height: 8),
                    Text(
                      'Generation history does not confirm saving, delivery or CA acceptance.',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 14),
                    history.when(
                      data: (runs) => Column(
                        children: [
                          if (runs.isEmpty)
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('No bundle generated for this month yet.'),
                            ),
                          for (final run in runs)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AppCard(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text('Export #${run.id}', style: theme.textTheme.titleMedium),
                                    const SizedBox(height: 3),
                                    Text(
                                      DateFormat('d MMM yyyy, HH:mm').format(run.createdAt.toLocal()),
                                      style: theme.textTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '${run.includedCount} monthly payments · format ${run.formatVersion}',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                    ExpansionTile(
                                      title: const Text('Verification details'),
                                      children: [
                                        SelectableText(
                                          run.manifestSha256,
                                          style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextButton.icon(
                                        onPressed: () async {
                                          await Clipboard.setData(ClipboardData(text: run.manifestSha256));
                                          if (context.mounted)
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(content: Text('Manifest SHA-256 copied')));
                                        },
                                        icon: const Icon(Icons.copy_outlined, size: 16),
                                        label: const Text('Copy manifest SHA-256'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      loading: () => const LinearProgressIndicator(),
                      error: (_, _) => const Text('Export history could not be loaded.'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget _metric(BuildContext context, String label, int count) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(label, style: Theme.of(context).textTheme.bodySmall),
    const SizedBox(height: 6),
    Text('$count', style: Theme.of(context).textTheme.displaySmall),
  ],
);
Widget _line(BuildContext context, String label, String value) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 6),
  child: Wrap(
    alignment: WrapAlignment.spaceBetween,
    spacing: 16,
    runSpacing: 4,
    children: [
      Text(label),
      Text(value, style: Theme.of(context).textTheme.titleMedium),
    ],
  ),
);
