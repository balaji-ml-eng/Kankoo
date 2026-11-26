import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ingestion/share/shortcuts_inbox.dart';
import '../../providers.dart';

class ShortcutsScreen extends ConsumerStatefulWidget {
  const ShortcutsScreen({super.key});
  @override
  ConsumerState<ShortcutsScreen> createState() => _ShortcutsScreenState();
}

class _ShortcutsScreenState extends ConsumerState<ShortcutsScreen> {
  ShortcutsStatus? _status;
  String? _error;
  bool _busy = false;
  late final AppLifecycleListener _lifecycle;
  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _load);
    Future.microtask(_load);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (!ref.read(shortcutsInboxProvider).isSupported) return;
    try {
      final status = await ref.read(shortcutsInboxProvider).status();
      if (mounted)
        setState(() {
          _status = status;
          _error = status.lastError;
        });
    } catch (_) {
      if (mounted)
        setState(() => _error = 'The forwarding service could not be opened. Close and reopen Kankoo, then retry.');
    }
  }

  Future<void> _enable(bool enabled) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(shortcutsInboxProvider).setEnabled(enabled);
      await _load();
    } catch (_) {
      if (mounted)
        setState(() => _error = 'Forwarding could not be changed. Your existing encrypted inbox has been kept.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final supported = ref.watch(shortcutsInboxProvider).isSupported;
    ref.listen(shareIntakeProvider, (_, _) => _load());
    final shares = ref.read(incomingSharesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('iPhone Shortcuts')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
          children: [
            Text('Your bank alert. Your private inbox.', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 12),
            const Text(
              'You choose which incoming messages Shortcuts forwards. Kankoo cannot read your Messages inbox.',
            ),
            const SizedBox(height: 20),
            if (supported)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Allow Shortcuts forwarding'),
                value: _status?.enabled ?? false,
                subtitle: const Text(
                  'Stored encrypted on this iPhone. Turning off stops new forwards and keeps pending records.',
                ),
                onChanged: _busy || _status == null ? null : _enable,
              )
            else
              const Text(
                'The native forwarding action is available on iPhone. Android can use its SMS source or share a message.',
              ),
            if (_status != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text('${_status!.pendingCount} messages waiting for import', style: theme.textTheme.titleMedium),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
              ),
            if (shares.unreadableNativeCount > 0)
              Text(
                '${shares.unreadableNativeCount} encrypted records could not be opened. Their files have been kept.',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            Wrap(
              spacing: 12,
              children: [
                OutlinedButton(onPressed: _busy ? null : _load, child: const Text('Refresh status')),
                OutlinedButton(
                  onPressed: _busy || !supported
                      ? null
                      : () async {
                          setState(() => _busy = true);
                          try {
                            await ref.read(shareIntakeProvider.notifier).retryPending();
                            await _load();
                          } finally {
                            if (mounted) setState(() => _busy = false);
                          }
                        },
                  child: const Text('Import pending messages'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Set up the automation', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            for (final step in [
              (
                '1',
                'Enable forwarding here',
                'Open Kankoo once while the iPhone is unlocked. This creates the device-bound inbox key.',
              ),
              (
                '2',
                'Choose the messages in Shortcuts',
                'In Apple Shortcuts, add a personal automation with the Message trigger. Filter your bank sender or a transaction phrase such as “debited”. Choose Run Immediately when available.',
              ),
              (
                '3',
                'Add Kankoo’s action',
                'Add “Forward bank message” from Kankoo. Set Bank message to the Content of Shortcut Input. Sender is optional; use the input’s Sender when available.',
              ),
              (
                '4',
                'Test with a sample first',
                'Run it with a made-up bank alert, then open Kankoo and review Activity. Check the sender and message content before enabling it for real bank alerts.',
              ),
              (
                '5',
                'Open and unlock Kankoo to import',
                'Forwarded messages wait encrypted until the foreground app is unlocked. Replayed inbox records do not create duplicate transactions.',
              ),
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 32, child: Text(step.$1, style: theme.textTheme.titleMedium)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(step.$2, style: theme.textTheme.titleMedium),
                          const SizedBox(height: 6),
                          Text(step.$3),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const Divider(),
            const SizedBox(height: 16),
            Text('What to expect', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text(
              'This forwards new messages matched by your automation; it does not scan old SMS. Apple controls when automations run. The encrypted inbox is unavailable before the first unlock after a restart. Bank senders, filters and locked-phone behavior need checking on your own iPhone.',
            ),
            const SizedBox(height: 12),
            const Text(
              'Prefer the native Kankoo action. The older kankoo:// link method opens the app and may require unlocking. No webhook or server is required. Cloud AI remains optional in AI Settings.',
            ),
          ],
        ),
      ),
    );
  }
}
