import 'package:flutter/material.dart';

import '../../documents/vault/pdf_vault.dart';
import '../../reconciliation/reconciliation_service.dart';
import '../../ui/ledger_theme.dart';

String reviewError(Object error) => switch (error) {
  ReconciliationException(:final message) => message,
  VaultException(:final message) => message,
  FormatException(:final message) => message,
  StateError(:final message) => message.toString(),
  ArgumentError(:final message) => message?.toString() ?? 'Check the entered value.',
  _ =>
    'The change could not be saved. Check payment balances and linked refunds, then try again. Your ledger was kept.',
};

Widget reviewNotice(BuildContext context, String message, {bool error = false, bool review = false}) => Container(
  width: double.infinity,
  margin: const EdgeInsets.symmetric(vertical: 12),
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
    border: Border.all(
      color: error
          ? LedgerColors.mismatch
          : review
          ? LedgerColors.review
          : Theme.of(context).colorScheme.outlineVariant,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
  child: Text(
    message,
    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: error ? LedgerColors.mismatch : null),
  ),
);

Widget evidenceBadge(BuildContext context, String status) {
  final color = switch (status) {
    'Evidence Matched' => LedgerColors.matched,
    'Mismatch' => LedgerColors.mismatch,
    'Needs Evidence' || 'Needs review' || 'Unreviewed' => LedgerColors.review,
    _ => Theme.of(context).colorScheme.onSurfaceVariant,
  };
  final dark = Theme.of(context).brightness == Brightness.dark;
  final textColor = switch (status) {
    'Evidence Matched' => dark ? const Color(0xFF75DAD0) : const Color(0xFF0B7166),
    'Unreviewed' || 'Needs Evidence' || 'Needs review' => dark ? const Color(0xFFF2B45F) : const Color(0xFF94500A),
    'Mismatch' => dark ? const Color(0xFFFFA49B) : const Color(0xFFB42318),
    _ => color,
  };
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.06),
      border: Border.all(color: color.withValues(alpha: 0.25)),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(status, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: textColor)),
  );
}

Future<T?> showLedgerSheet<T>(BuildContext context, Widget child) => showModalBottomSheet<T>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  backgroundColor: Theme.of(context).colorScheme.surface,
  constraints: const BoxConstraints(maxWidth: 720),
  builder: (context) => FractionallySizedBox(heightFactor: 0.93, child: child),
);

Widget sheetPadding(BuildContext context, Widget child) =>
    Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 24 + MediaQuery.viewInsetsOf(context).bottom), child: child);
