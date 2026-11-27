import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/money_minor.dart';
import '../../data/db/database.dart';
import '../../providers.dart';
import '../../reconciliation/reconciliation_service.dart';
import '../../ui/ledger_brand.dart';
import '../../ui/ledger_theme.dart';
import '../../ui/widgets.dart';
import '../activity/transaction_sheet.dart';
import '../activity/add_transaction_sheet.dart';
import '../reconciliation/reconciliation_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(selectedMonthProvider);
    final review = ref.watch(reconciliationMonthProvider(month));
    final payments = ref.watch(monthTxnsProvider);
    final snapshot = review.value;
    final rows = snapshot?.rows ?? const <ReviewRow>[];
    final unreviewed = rows.where((r) => !r.reviewed).length;
    final missing = snapshot?.needsEvidence ?? 0;
    final bankChecks = rows
        .where((r) => r.transaction.status == TxnStatus.needsReview || r.status == 'Mismatch')
        .length;
    final classified = rows.where((r) => r.reviewed).length;
    final period = DateFormat('yyyy-MM').format(month);
    void books(String filter) => context.go('/books?month=$period&filter=${Uri.encodeQueryComponent(filter)}');
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(reconciliationMonthProvider(month));
            ref.invalidate(monthTxnsProvider);
            if (ref.read(smsSyncProvider).enabled) await ref.read(smsSyncProvider.notifier).sync();
          },
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                sliver: SliverList.list(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const LedgerWordmark(),
                        IconButton.outlined(
                          tooltip: 'Add transaction',
                          onPressed: () => showAddTransactionSheet(context),
                          icon: const Icon(Icons.add, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            DateFormat('MMMM yyyy').format(month),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Previous month',
                          onPressed: () => ref.read(selectedMonthProvider.notifier).shift(-1),
                          icon: const Icon(Icons.chevron_left),
                        ),
                        IconButton(
                          tooltip: 'Next month',
                          onPressed: ref.read(selectedMonthProvider.notifier).isCurrent
                              ? null
                              : () => ref.read(selectedMonthProvider.notifier).shift(1),
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    review.when(
                      loading: () => const _ReviewLoading(),
                      error: (_, _) => AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Your monthly review could not load.', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            const Text('Your records are kept. Refresh to try again.'),
                            TextButton(
                              onPressed: () => ref.invalidate(reconciliationMonthProvider(month)),
                              child: const Text('Retry monthly review'),
                            ),
                          ],
                        ),
                      ),
                      data: (data) => _OutflowPanel(
                        snapshot: data,
                        onContinue: data.rows.isEmpty && payments.value?.isEmpty == true
                            ? () => context.push('/statements/import')
                            : () => books(
                                unreviewed > 0
                                    ? 'Unreviewed'
                                    : missing > 0
                                    ? 'Needs Evidence'
                                    : 'All',
                              ),
                        empty: data.rows.isEmpty && payments.value?.isEmpty == true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (snapshot != null && rows.isNotEmpty) ...[
                      const LedgerEyebrow('Your next steps'),
                      const SizedBox(height: 12),
                      AppCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Column(
                          children: [
                            _MonthTask(
                              title: 'Classify payments',
                              detail: unreviewed == 0
                                  ? 'Every payment has a business split'
                                  : '$unreviewed still to review',
                              count: unreviewed,
                              onTap: () => books(unreviewed == 0 ? 'All' : 'Unreviewed'),
                            ),
                            const Divider(height: 1),
                            _MonthTask(
                              title: 'Complete the evidence',
                              detail: missing == 0
                                  ? 'No business payment is missing evidence'
                                  : '$missing business payment${missing == 1 ? '' : 's'} need${missing == 1 ? 's' : ''} attention',
                              count: missing,
                              onTap: () => books(missing == 0 ? 'Business' : 'Needs Evidence'),
                            ),
                            if (bankChecks > 0) ...[
                              const Divider(height: 1),
                              _MonthTask(
                                title: 'Check bank details',
                                detail: '$bankChecks flagged or inconsistent payment${bankChecks == 1 ? '' : 's'}',
                                count: bankChecks,
                                onTap: () => books('Bank checks'),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '$classified of ${rows.length} INR payments classified. Self-transfers excluded.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 7),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(value: classified / rows.length, minHeight: 3),
                      ),
                      const SizedBox(height: 22),
                    ],
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => context.push('/statements/import'),
                          icon: const Icon(Icons.upload_file_outlined, size: 18),
                          label: const Text('Import statement'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => context.push('/ca/export?month=$period'),
                          icon: const Icon(Icons.folder_zip_outlined, size: 18),
                          label: const Text('CA bundle'),
                        ),
                      ],
                    ),
                    if (snapshot != null && rows.isEmpty) ...[
                      const SizedBox(height: 22),
                      Text('Start with your bank statement', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 6),
                      const Text('Import a CSV, verify the balance, then decide what belongs to your business.'),
                      TextButton(
                        onPressed: () => context.push('/notifications'),
                        child: const Text('Set up automatic capture'),
                      ),
                    ],
                    const SizedBox(height: 26),
                    Row(
                      children: [
                        const Expanded(child: LedgerEyebrow('Recent payments')),
                        TextButton(onPressed: () => context.go('/activity'), child: const Text('View all')),
                      ],
                    ),
                    payments.when(
                      loading: () =>
                          const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: LinearProgressIndicator()),
                      error: (_, _) => const Text('Payments could not load. Pull down to refresh.'),
                      data: (list) => list.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                'Your imported and manual payments will appear here.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            )
                          : Column(
                              children: [
                                for (final view in list.take(4)) ...[
                                  TransactionTile(
                                    view: view,
                                    showDate: true,
                                    onTap: () => showTransactionSheet(context, view.txn.id),
                                  ),
                                  const Divider(height: 1),
                                ],
                                if (list.any((v) => v.txn.currency != 'INR' || v.txn.isTransfer))
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Text(
                                      'Foreign-currency and self-transfer rows remain visible in Activity. They are outside the INR business review.',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 110),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutflowPanel extends StatelessWidget {
  const _OutflowPanel({required this.snapshot, required this.onContinue, required this.empty});
  final ReviewSnapshot snapshot;
  final VoidCallback onContinue;
  final bool empty;
  @override
  Widget build(BuildContext context) {
    const ink = LedgerColors.midnight, paper = Color(0xFFF4F5F7);
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [LedgerColors.midnight, Color(0xFF294376)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF354D85)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'NET BUSINESS OUTFLOW',
            style: text.labelSmall?.copyWith(color: paper.withValues(alpha: 0.7), letterSpacing: 1.7),
          ),
          const SizedBox(height: 14),
          Semantics(
            label: 'Net business outflow ${formatInrMinor(snapshot.businessTotal)}',
            child: ExcludeSemantics(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  formatInrMinor(snapshot.businessTotal),
                  style: text.displayMedium?.copyWith(color: paper, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('Current business splits · INR', style: text.bodySmall?.copyWith(color: paper.withValues(alpha: 0.7))),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onContinue,
            style: FilledButton.styleFrom(backgroundColor: paper, foregroundColor: ink),
            label: Text(empty ? 'Import your first statement' : 'Review this month'),
            icon: const Icon(Icons.arrow_forward, size: 18),
          ),
        ],
      ),
    );
  }
}

class _MonthTask extends StatelessWidget {
  const _MonthTask({required this.title, required this.detail, required this.count, required this.onTap});
  final String title, detail;
  final int count;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 17),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Icon(
              count == 0 ? Icons.check_circle_outline : Icons.circle_outlined,
              size: 20,
              color: count == 0 ? Theme.of(context).colorScheme.onSurfaceVariant : LedgerColors.review,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 3),
                Text(detail, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.arrow_forward_ios, size: 13),
        ],
      ),
    ),
  );
}

class _ReviewLoading extends StatelessWidget {
  const _ReviewLoading();
  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LedgerEyebrow('Monthly review'),
        const SizedBox(height: 24),
        const LinearProgressIndicator(),
        const SizedBox(height: 16),
        Text('Loading your ledger…', style: Theme.of(context).textTheme.bodySmall),
      ],
    ),
  );
}
