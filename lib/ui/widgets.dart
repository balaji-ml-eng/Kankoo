import 'package:flutter/material.dart';

import '../core/theme/icons.dart';

import '../core/format.dart';
import '../core/money_minor.dart';
import 'ledger_theme.dart';
import '../core/theme/category_icons.dart';
import '../core/theme/palette.dart';
import '../data/db/database.dart';

extension ThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

/// Rounded-square icon tile tinted with the category color.
class CategoryBadge extends StatelessWidget {
  const CategoryBadge({super.key, this.category, this.size = 44, this.isTransfer = false});

  final Category? category;
  final double size;
  final bool isTransfer;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.onSurfaceVariant;
    final icon = isTransfer ? PhosphorIconsFill.arrowsLeftRight : CategoryIcons.of(category?.icon);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: context.colors.outlineVariant),
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: color, size: size * 0.5),
    );
  }
}

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding = const EdgeInsets.all(20), this.onTap, this.color});

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) => Card(
    color: color,
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(padding: padding, child: child),
    ),
  );
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 8, 0, 8),
    child: Row(
      children: [
        Expanded(
          child: Text(title, style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        ),
        if (action != null) TextButton(onPressed: onAction, child: Text(action!)),
      ],
    ),
  );
}

String txnTitle(Transaction t) =>
    t.merchant ?? t.counterparty ?? (t.direction == TxnDirection.credit ? 'Money received' : 'Payment');

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.view, this.onTap, this.showDate = false});
  final TxnView view;
  final VoidCallback? onTap;
  final bool showDate;
  @override
  Widget build(BuildContext context) {
    final t = view.txn, credit = view.txn.direction == TxnDirection.credit;
    final subtitle = [
      if (t.isTransfer) 'Transfer' else view.category?.name ?? 'Uncategorised',
      showDate ? dayLabel(t.occurredAt) : timeLabel(t.occurredAt),
      if (view.account != null) view.account!.last4 == null ? view.account!.name : '\u2022\u2022${view.account!.last4}',
    ].join('  \u00b7  ');
    final amount =
        '${credit ? '+' : '\u2212'}${t.currency == 'INR' ? formatInrMinor(t.amountMinor) : money(t.amountMinor, currency: t.currency)}';
    Widget details(bool compact) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                txnTitle(t),
                maxLines: compact ? 2 : 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.titleMedium,
              ),
            ),
            if (t.status == TxnStatus.needsReview)
              const Padding(
                padding: EdgeInsets.only(left: 5),
                child: Icon(Icons.error_outline, size: 16, color: LedgerColors.review),
              ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          maxLines: compact ? 2 : 1,
          overflow: TextOverflow.ellipsis,
          style: context.text.bodySmall?.copyWith(color: context.colors.onSurfaceVariant),
        ),
      ],
    );
    Widget value(bool compact) => Column(
      crossAxisAlignment: compact ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: compact ? Alignment.centerLeft : Alignment.centerRight,
          child: Text(
            amount,
            style: context.text.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: t.isTransfer ? context.colors.onSurfaceVariant : context.colors.onSurface,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        if (t.isForeign) ForeignAmountNote(txn: t),
      ],
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact =
                constraints.maxWidth < 300 || MediaQuery.textScalerOf(context).scale(16) > 20 || amount.length > 18;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategoryBadge(category: view.category, isTransfer: t.isTransfer, size: 40),
                const SizedBox(width: 12),
                if (compact)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [details(true), const SizedBox(height: 8), value(true)],
                    ),
                  )
                else ...[
                  Expanded(flex: 4, child: details(false)),
                  const SizedBox(width: 12),
                  Expanded(flex: 3, child: value(false)),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Under a foreign amount: what it came to at home ("≈ ₹1,045.30"), or that
/// it isn't counted in totals yet.
class ForeignAmountNote extends StatelessWidget {
  const ForeignAmountNote({super.key, required this.txn, this.style});

  final Transaction txn;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final home = txn.homeMinor;
    return Text(
      home == null ? 'not in totals' : '≈ ${money(home)}',
      style: (style ?? context.text.labelSmall)?.copyWith(
        color: home == null ? Palette.amber : context.colors.onSurfaceVariant,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, required this.message, this.action});

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: context.colors.outlineVariant),
            color: context.colors.surface,
          ),
          child: Icon(icon, size: 28, color: context.colors.onSurfaceVariant),
        ),
        const SizedBox(height: 20),
        Text(title, style: context.text.titleLarge, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: context.text.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant),
        ),
        if (action != null) ...[const SizedBox(height: 20), action!],
      ],
    ),
  );
}

/// Small pill used for metadata (mode, account, source).
class InfoPill extends StatelessWidget {
  const InfoPill({super.key, required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.colors.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: context.colors.surfaceContainerHigh, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: c),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.text.labelMedium?.copyWith(color: c, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

IconData modeIcon(PaymentMode m) => switch (m) {
  PaymentMode.upi => PhosphorIconsBold.lightning,
  PaymentMode.card => PhosphorIconsBold.creditCard,
  PaymentMode.atm => PhosphorIconsBold.money,
  PaymentMode.cash => PhosphorIconsBold.money,
  PaymentMode.wallet => PhosphorIconsBold.wallet,
  _ => PhosphorIconsBold.bank,
};

String modeLabel(PaymentMode m) => switch (m) {
  PaymentMode.upi => 'UPI',
  PaymentMode.card => 'Card',
  PaymentMode.netbanking => 'Net banking',
  PaymentMode.neft => 'NEFT',
  PaymentMode.imps => 'IMPS',
  PaymentMode.rtgs => 'RTGS',
  PaymentMode.atm => 'ATM',
  PaymentMode.wallet => 'Wallet',
  PaymentMode.cash => 'Cash',
  PaymentMode.other => 'Bank',
};
