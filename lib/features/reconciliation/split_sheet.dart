import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/money_minor.dart';
import '../../reconciliation/reconciliation_service.dart';
import 'reconciliation_providers.dart';
import 'reconciliation_widgets.dart';

class BusinessSplitSheet extends ConsumerStatefulWidget {
  const BusinessSplitSheet({super.key, required this.row});
  final ReviewRow row;
  @override
  ConsumerState<BusinessSplitSheet> createState() => _BusinessSplitSheetState();
}

class _BusinessSplitSheetState extends ConsumerState<BusinessSplitSheet> {
  late final TextEditingController _percent, _purpose;
  bool _remember = false, _busy = false;
  String? _error;
  int? get _bps {
    try {
      final value = parseInrMinor(_percent.text);
      return value <= 10000 ? value : null;
    } on FormatException {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _percent = TextEditingController(text: (widget.row.transaction.businessUseBps / 100).toStringAsFixed(2));
    _purpose = TextEditingController(text: widget.row.classification?.businessPurpose ?? '');
  }

  @override
  void dispose() {
    _percent.dispose();
    _purpose.dispose();
    super.dispose();
  }

  void _set(int bps) => setState(() => _percent.text = (bps / 100).toStringAsFixed(2));
  Future<void> _save() async {
    final bps = _bps;
    if (bps == null) {
      setState(() => _error = 'Enter a percentage between 0 and 100, with at most two decimals.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(reconciliationServiceProvider)
          .classify(widget.row.transaction.id, bps, remember: _remember, purpose: _purpose.text);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) setState(() => _error = reviewError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context), t = widget.row.transaction;
    return sheetPadding(
      context,
      ListView(
        children: [
          Text('Business share', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(t.merchant ?? 'Payment', style: theme.textTheme.titleMedium),
          Text(formatInrMinor(t.amountMinor), style: theme.textTheme.headlineMedium),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final bps in [0, 5000, 10000])
                ChoiceChip(
                  label: Text('${bps ~/ 100}%'),
                  selected: _bps == bps,
                  onSelected: _busy ? null : (_) => _set(bps),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Slider(
            value: (_bps ?? 0).toDouble(),
            min: 0,
            max: 10000,
            divisions: 10000,
            label: '${(_bps ?? 0) / 100}%',
            onChanged: _busy ? null : (value) => _set(value.round()),
          ),
          TextField(
            key: const ValueKey('business-percent'),
            controller: _percent,
            enabled: !_busy,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Business use', suffixText: '%'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          if (_bps != null)
            Text(
              '${formatInrMinor(businessMinor(t.amountMinor, _bps!))} business · ${formatInrMinor(t.amountMinor - businessMinor(t.amountMinor, _bps!))} personal',
              style: theme.textTheme.bodyMedium,
            ),
          const SizedBox(height: 20),
          TextField(
            controller: _purpose,
            enabled: !_busy,
            maxLength: 300,
            minLines: 1,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Business purpose', hintText: 'Optional note for your CA'),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Remember for this merchant'),
            subtitle: const Text('Exact name match on future debit payments'),
            value: _remember,
            onChanged: _busy || t.merchant == null || t.merchant!.trim().isEmpty
                ? null
                : (v) => setState(() => _remember = v),
          ),
          const SizedBox(height: 12),
          Text(
            'This split records business use. It does not determine GST credit eligibility. Evidence must cover the full payment.',
            style: theme.textTheme.bodySmall,
          ),
          if (_error != null) reviewNotice(context, _error!, error: true),
          const SizedBox(height: 20),
          FilledButton(onPressed: _busy ? null : _save, child: Text(_busy ? 'Saving split…' : 'Save business share')),
        ],
      ),
    );
  }
}
