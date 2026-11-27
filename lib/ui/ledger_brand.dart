import 'package:flutter/material.dart';

class LedgerWordmark extends StatelessWidget {
  const LedgerWordmark({super.key});
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: colors.primary, borderRadius: BorderRadius.circular(8)),
          child: Text(
            'K',
            textScaler: TextScaler.noScaling,
            style: TextStyle(color: colors.onPrimary, fontSize: 18, height: 1, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 9),
        Text('Kankoo', style: Theme.of(context).textTheme.titleLarge?.copyWith(letterSpacing: -0.7)),
      ],
    );
  }
}

class LedgerEyebrow extends StatelessWidget {
  const LedgerEyebrow(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.6, fontWeight: FontWeight.w700),
  );
}
