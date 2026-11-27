import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/money_minor.dart';
import '../../data/db/database.dart';
import '../../reconciliation/reconciliation_service.dart';
import '../../ui/ledger_theme.dart';
import 'evidence_sheet.dart';
import 'invoice_editor.dart';
import 'reconciliation_providers.dart';
import 'reconciliation_widgets.dart';
import 'split_sheet.dart';

class ReconciliationScreen extends ConsumerStatefulWidget {
  const ReconciliationScreen({super.key, this.initialMonth, this.initialFilter});
  final DateTime? initialMonth;
  final String? initialFilter;
  @override
  ConsumerState<ReconciliationScreen> createState() => _ReconciliationScreenState();
}

class _ReconciliationScreenState extends ConsumerState<ReconciliationScreen> {
  final _filterScroll = ScrollController();
  late DateTime _month;
  String _filter = 'Unreviewed', _search = '';
  String? _error;
  int? _busy;
  ({int id, int bps, String merchant})? _offer;
  @override
  void initState() {
    super.initState();
    final date = widget.initialMonth ?? DateTime.now();
    _month = DateTime(date.year, date.month);
    if (const [
      'Unreviewed',
      'All',
      'Business',
      'Personal',
      'Needs Evidence',
      'Bank checks',
    ].contains(widget.initialFilter)) {
      _filter = widget.initialFilter!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _filterScroll.hasClients && const ['Needs Evidence', 'Bank checks'].contains(_filter)) {
        _filterScroll.jumpTo(_filterScroll.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _filterScroll.dispose();
    super.dispose();
  }

  Future<void> _classify(ReviewRow row, int bps, {bool remember = false}) async {
    setState(() {
      _busy = row.transaction.id;
      _error = null;
    });
    try {
      await ref.read(reconciliationServiceProvider).classify(row.transaction.id, bps, remember: remember);
      if (mounted) {
        setState(
          () => _offer = remember || normalizeBusinessMerchant(row.transaction.merchant ?? '').isEmpty
              ? null
              : (id: row.transaction.id, bps: bps, merchant: row.transaction.merchant!),
        );
      }
    } catch (e) {
      if (mounted) setState(() => _error = reviewError(e));
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  @override
  Widget build(BuildContext context) => Theme(
    data: ledgerTheme(Theme.of(context).brightness),
    child: Builder(builder: _build),
  );

  Widget _build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(reconciliationMonthProvider(_month));
    final snapshot = state.value;
    final rows =
        snapshot?.rows.where((r) {
          final query = _search.toLowerCase();
          if (query.isNotEmpty &&
              !'${r.transaction.merchant ?? ''} ${r.transaction.reference ?? ''} ${r.transaction.note ?? ''}'
                  .toLowerCase()
                  .contains(query)) {
            return false;
          }
          return switch (_filter) {
            'Unreviewed' => !r.reviewed,
            'Business' => r.transaction.businessUseBps > 0,
            'Personal' => r.reviewed && r.transaction.businessUseBps == 0,
            'Needs Evidence' => r.transaction.businessUseBps > 0 && r.status != 'Evidence Matched',
            'Bank checks' => r.transaction.status == TxnStatus.needsReview || r.status == 'Mismatch',
            _ => true,
          };
        }).toList() ??
        [];
    return Scaffold(
      appBar: AppBar(title: Text('Monthly books', style: theme.textTheme.titleMedium)),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                DateFormat('MMMM yyyy').format(_month),
                                style: theme.textTheme.headlineMedium,
                              ),
                            ),
                            IconButton(
                              tooltip: 'Previous month',
                              onPressed: _busy != null
                                  ? null
                                  : () => setState(() {
                                      _month = DateTime(_month.year, _month.month - 1);
                                      _offer = null;
                                    }),
                              icon: const Icon(Icons.chevron_left),
                            ),
                            IconButton(
                              tooltip: 'Next month',
                              onPressed: _busy != null
                                  ? null
                                  : () => setState(() {
                                      _month = DateTime(_month.year, _month.month + 1);
                                      _offer = null;
                                    }),
                              icon: const Icon(Icons.chevron_right),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Review the split. Keep the evidence.', style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.symmetric(horizontal: BorderSide(color: theme.colorScheme.outlineVariant)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                spacing: 16,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text('Net business outflow', style: theme.textTheme.bodySmall),
                                  Text(
                                    snapshot == null ? '—' : formatInrMinor(snapshot.businessTotal),
                                    style: theme.textTheme.headlineMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                snapshot == null
                                    ? 'Loading your monthly ledger…'
                                    : '${snapshot.rows.where((r) => !r.reviewed).length} unreviewed · ${snapshot.needsEvidence} need evidence',
                                style: theme.textTheme.bodySmall,
                              ),
                              const SizedBox(height: 4),
                              Text('Business debits less business credits', style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final columns = MediaQuery.textScalerOf(context).scale(14) > 18 ? 2 : 4;
                            return Wrap(
                              children:
                                  [
                                        _BookAction(
                                          icon: Icons.upload_file_outlined,
                                          label: 'Import CSV',
                                          onPressed: _busy != null ? null : () => context.push('/statements/import'),
                                        ),
                                        _BookAction(
                                          icon: Icons.description_outlined,
                                          label: 'Invoices',
                                          onPressed: _busy != null
                                              ? null
                                              : () => showLedgerSheet(context, const InvoiceLibrary()),
                                        ),
                                        _BookAction(
                                          icon: Icons.tune,
                                          label: 'Rules',
                                          onPressed: snapshot == null || _busy != null
                                              ? null
                                              : () => _showRules(context, snapshot),
                                        ),
                                        _BookAction(
                                          icon: Icons.folder_zip_outlined,
                                          label: 'Export for CA',
                                          onPressed: _busy != null
                                              ? null
                                              : () => context.push(
                                                  '/ca/export?month=${DateFormat('yyyy-MM').format(_month)}',
                                                ),
                                        ),
                                      ]
                                      .map((action) => SizedBox(width: constraints.maxWidth / columns, child: action))
                                      .toList(),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Find a payment',
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (v) => setState(() => _search = v),
                        ),
                        const SizedBox(height: 14),
                        SingleChildScrollView(
                          controller: _filterScroll,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            spacing: 8,
                            children: [
                              for (final filter in [
                                'Unreviewed',
                                'All',
                                'Business',
                                'Personal',
                                'Needs Evidence',
                                'Bank checks',
                              ])
                                ChoiceChip(
                                  label: Text(filter),
                                  selected: _filter == filter,
                                  onSelected: (_) => setState(() => _filter = filter),
                                ),
                            ],
                          ),
                        ),
                        if (_error != null) reviewNotice(context, _error!, error: true),
                        if (_offer != null)
                          Container(
                            margin: const EdgeInsets.only(top: 16),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              border: Border.all(color: theme.colorScheme.outlineVariant),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Always mark ${_offer!.merchant} as ${_offer!.bps / 100}% business?',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                Text(
                                  'Exact merchant match. Future debit payments only.',
                                  style: theme.textTheme.bodySmall,
                                ),
                                Wrap(
                                  spacing: 8,
                                  children: [
                                    TextButton(
                                      onPressed: _busy != null
                                          ? null
                                          : () async {
                                              final offer = _offer!;
                                              final row = snapshot!.rows
                                                  .where((r) => r.transaction.id == offer.id)
                                                  .firstOrNull;
                                              if (row != null) await _classify(row, offer.bps, remember: true);
                                            },
                                      child: const Text('Always use this split'),
                                    ),
                                    TextButton(
                                      onPressed: () => setState(() => _offer = null),
                                      child: const Text('Just this payment'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 12),
                        Text(
                          'INR only · self-transfers excluded. GST review is separate.',
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                if (state.isLoading && snapshot == null)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  )
                else if (state.hasError)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          reviewNotice(
                            context,
                            'The monthly ledger could not be loaded. Your records were kept.',
                            error: true,
                          ),
                          OutlinedButton(
                            onPressed: () => ref.invalidate(reconciliationMonthProvider(_month)),
                            child: const Text('Try again'),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (rows.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot?.rows.isEmpty == true
                                ? 'Start with your bank statement.'
                                : 'No payments in this view.',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            snapshot?.rows.isEmpty == true
                                ? 'Import a reconciled CSV, then review each payment here.'
                                : 'Choose All to review your other payments or adjust the search.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList.builder(
                      itemCount: rows.length,
                      itemBuilder: (context, index) => _row(context, rows[index]),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 48)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, ReviewRow row) {
    final t = row.transaction, theme = Theme.of(context);
    final busy = _busy != null;
    return Container(
      key: ValueKey('review-row-${t.id}'),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 12,
            runSpacing: 6,
            children: [
              Text(
                '${DateFormat('dd MMM yyyy').format(t.occurredAt)}${t.direction == TxnDirection.credit ? ' · Credit / refund' : ''}',
                style: theme.textTheme.bodySmall,
              ),
              evidenceBadge(context, row.status),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 16,
            runSpacing: 6,
            children: [
              Text(t.merchant ?? 'Payment without a merchant', style: theme.textTheme.titleMedium),
              Text(formatInrMinor(t.amountMinor), style: theme.textTheme.titleLarge),
            ],
          ),
          if (t.businessUseBps > 0)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '${formatInrMinor(row.businessShare)} business · ${t.businessUseBps / 100}% of the payment',
                style: theme.textTheme.bodySmall,
              ),
            ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              ChoiceChip(
                key: ValueKey('personal-${t.id}'),
                label: const Text('Personal'),
                selected: row.reviewed && t.businessUseBps == 0,
                onSelected: busy ? null : (_) => _classify(row, 0),
              ),
              ChoiceChip(
                key: ValueKey('business-${t.id}'),
                label: const Text('100% Business'),
                selected: row.reviewed && t.businessUseBps == 10000,
                onSelected: busy ? null : (_) => _classify(row, 10000),
              ),
              ActionChip(
                key: ValueKey('split-${t.id}'),
                label: Text(
                  t.businessUseBps > 0 && t.businessUseBps < 10000 ? 'Split · ${t.businessUseBps / 100}%' : 'Split…',
                ),
                onPressed: busy ? null : () => showLedgerSheet(context, BusinessSplitSheet(row: row)),
              ),
            ],
          ),
          if (t.businessUseBps > 0)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                key: ValueKey('evidence-${t.id}'),
                onPressed: busy
                    ? null
                    : () => showLedgerSheet(context, EvidenceSheet(transactionId: t.id, month: _month)),
                icon: const Icon(Icons.attach_file, size: 18),
                label: Text(row.status == 'Evidence Matched' ? 'Review linked evidence' : 'Match invoice evidence'),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showRules(BuildContext context, ReviewSnapshot snapshot) =>
      showLedgerSheet(context, _RulesSheet(month: _month));
}

class _BookAction extends StatelessWidget {
  const _BookAction({required this.icon, required this.label, required this.onPressed});
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 21),
        const SizedBox(height: 7),
        Text(label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelSmall),
      ],
    ),
  );
}

class _RulesSheet extends ConsumerStatefulWidget {
  const _RulesSheet({required this.month});
  final DateTime month;
  @override
  ConsumerState<_RulesSheet> createState() => _RulesSheetState();
}

class _RulesSheetState extends ConsumerState<_RulesSheet> {
  bool _busy = false;
  String? _message;
  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      await action();
    } catch (e) {
      if (mounted) setState(() => _message = reviewError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rules = ref.watch(reconciliationMonthProvider(widget.month)).value?.rules ?? [];
    return sheetPadding(
      context,
      ListView(
        children: [
          Text('Merchant memory', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text(
            'Rules match the exact normalised merchant name. Your reviewed payments and GST eligibility stay as recorded.',
          ),
          if (_message != null) reviewNotice(context, _message!),
          const SizedBox(height: 16),
          if (rules.isEmpty)
            const Text('Review a payment and choose “Always use this split” to remember its merchant.'),
          for (final rule in rules)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(rule.merchantPattern),
              subtitle: Text('${rule.businessUseBps / 100}% business · ${rule.provenance}'),
              trailing: IconButton(
                tooltip: 'Forget ${rule.merchantPattern}',
                onPressed: _busy ? null : () => _run(() => ref.read(reconciliationServiceProvider).removeRule(rule.id)),
                icon: const Icon(Icons.close),
              ),
            ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: _busy || rules.isEmpty
                ? null
                : () => _run(() async {
                    final count = await ref.read(reconciliationServiceProvider).applyRules(widget.month);
                    if (mounted) setState(() => _message = '$count unreviewed debit payments updated.');
                  }),
            child: const Text('Apply rules to unreviewed payments'),
          ),
        ],
      ),
    );
  }
}
