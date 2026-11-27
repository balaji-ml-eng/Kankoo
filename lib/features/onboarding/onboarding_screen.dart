import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/icons.dart';

import '../../core/currency.dart';
import '../../providers.dart';
import '../../ui/widgets.dart';
import '../../ui/ledger_brand.dart';
import '../settings/currency_tile.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  var _months = 6;
  var _busy = false;
  String? _error;

  Future<void> _connect() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final ok = await ref.read(smsSyncProvider.notifier).connect(months: _months);
      if (!mounted) return;
      if (ok) {
        ref.read(onboardedProvider.notifier).complete();
      } else {
        final err = ref.read(smsSyncProvider).error;
        setState(() => _error = err ?? 'Could not import SMS. Please try again.');
      }
    } catch (_) {
      if (mounted) setState(() => _error = 'Could not connect SMS. Please try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final supported = ref.read(smsSourceProvider).isSupported;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const LedgerWordmark(),
                    const SizedBox(height: 28),
                    const LedgerEyebrow('Your business. Your books.'),
                    const SizedBox(height: 12),
                    Text('A clear month.\nA simpler handoff.', style: context.text.displaySmall),
                    const SizedBox(height: 14),
                    Text(
                      'Import payments. Match invoices. Give your CA a month they can verify.',
                      style: context.text.bodyLarge?.copyWith(color: context.colors.onSurfaceVariant, height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    const LedgerEvidenceIllustration(),
                    const SizedBox(height: 12),
                    const _Point(
                      icon: PhosphorIconsFill.shieldCheck,
                      text: 'Your ledger and invoice PDFs stay encrypted on this device.',
                    ),
                    const SizedBox(height: 24),
                    const _CurrencyRow(),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: _busy
                          ? null
                          : () {
                              ref.read(onboardedProvider.notifier).complete();
                              context.go('/statements/import');
                            },
                      icon: const Icon(Icons.upload_file_outlined, size: 19),
                      label: const Text('Start with a bank CSV'),
                    ),
                    const SizedBox(height: 12),
                    if (supported)
                      ExpansionTile(
                        title: const Text('Connect SMS (optional)'),
                        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Import history',
                            style: context.text.labelLarge?.copyWith(color: context.colors.onSurfaceVariant),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [
                              for (final m in const [1, 3, 6, 12])
                                ChoiceChip(
                                  label: Text(m == 12 ? '1 year' : '$m mo'),
                                  selected: _months == m,
                                  onSelected: _busy ? null : (_) => setState(() => _months = m),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: _busy ? null : _connect,
                            icon: _busy
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(PhosphorIconsBold.chatText),
                            label: Text(_busy ? 'Connecting and importing…' : 'Allow SMS and import'),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Android will ask for SMS access. You can skip this and connect later in Settings.',
                            style: context.text.bodySmall,
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 12),
                            Text(_error!, style: TextStyle(color: context.colors.error)),
                            if (_error!.contains('permission'))
                              TextButton(
                                onPressed: () async {
                                  try {
                                    await ref.read(smsSourceProvider).openSettings();
                                  } catch (_) {
                                    if (mounted) {
                                      setState(
                                        () => _error = 'Open Android Settings → Apps → Kankoo → Permissions → SMS, then return and try again.',
                                      );
                                    }
                                  }
                                },
                                child: const Text('Open app permissions'),
                              ),
                          ],
                        ],
                      ),
                    const SizedBox(height: 4),
                    Center(
                      child: TextButton(
                        onPressed: _busy ? null : () => ref.read(onboardedProvider.notifier).complete(),
                        child: Text(supported ? 'Skip for now' : 'Get started'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The home currency, defaulted from the device locale, with a way to change it.
class _CurrencyRow extends ConsumerWidget {
  const _CurrencyRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = ref.watch(homeCurrencyProvider);
    return Row(
      children: [
        Icon(PhosphorIconsRegular.coins, size: 20, color: context.colors.onSurfaceVariant),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Currency: ${currencySymbol(code)} ${currencyFor(code)?.name ?? code}',
            style: context.text.bodyMedium,
          ),
        ),
        TextButton(onPressed: () => changeHomeCurrency(context, ref, confirm: false), child: const Text('Change')),
      ],
    );
  }
}

class _Point extends StatelessWidget {
  const _Point({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Icon(icon, color: context.colors.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: context.text.bodyMedium)),
      ],
    ),
  );
}
