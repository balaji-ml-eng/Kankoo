import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../ingestion/notifications/notification_intake.dart';
import '../../providers.dart';
import '../../ui/ledger_theme.dart';
import '../reconciliation/reconciliation_widgets.dart';

const notificationApps = {
  'com.google.android.apps.nbu.paisa.user': 'Google Pay',
  'com.phonepe.app': 'PhonePe',
  'net.one97.paytm': 'Paytm',
  'com.snapwork.hdfc': 'HDFC Bank',
  'com.csam.icici.bank.imobile': 'ICICI iMobile',
  'com.sbi.lotusintouch': 'SBI YONO',
  'com.axis.mobile': 'Axis Mobile',
  'com.msf.kbank.mobile': 'Kotak Bank',
};

class NotificationCaptureState {
  const NotificationCaptureState({
    this.enabled = false,
    this.accessGranted = false,
    this.packages = const {},
    this.pending = 0,
    this.quarantined = 0,
    this.captureError = false,
    this.processingError = false,
    this.lastProcessed,
  });
  final bool enabled, accessGranted, captureError, processingError;
  final Set<String> packages;
  final int pending, quarantined;
  final DateTime? lastProcessed;
  factory NotificationCaptureState.fromMap(Map<Object?, Object?> m) => NotificationCaptureState(
    enabled: m['enabled'] == true,
    accessGranted: m['accessGranted'] == true,
    packages: (m['packages'] as List? ?? []).cast<String>().toSet(),
    pending: m['pending'] as int? ?? 0,
    quarantined: m['quarantined'] as int? ?? 0,
    captureError: m['captureError'] == true,
    processingError: m['processingError'] == true,
    lastProcessed: m['lastProcessed'] is int && (m['lastProcessed'] as int) > 0
        ? DateTime.fromMillisecondsSinceEpoch(m['lastProcessed'] as int)
        : null,
  );
}

class NotificationCaptureApi {
  bool get supported => Platform.isAndroid;
  Future<NotificationCaptureState> status() async =>
      NotificationCaptureState.fromMap((await notificationChannel.invokeMapMethod<Object?, Object?>('status'))!);
  Future<void> configure(bool enabled, Set<String> packages) =>
      notificationChannel.invokeMethod<void>('configure', {'enabled': enabled, 'packages': packages.toList()..sort()});
  Future<void> openSettings() => notificationChannel.invokeMethod<void>('openSettings');
  Future<void> retry() => notificationChannel.invokeMethod<void>('retry');
}

final notificationCaptureApiProvider = Provider((_) => NotificationCaptureApi());

class NotificationCaptureScreen extends ConsumerStatefulWidget {
  const NotificationCaptureScreen({super.key});
  @override
  ConsumerState<NotificationCaptureScreen> createState() => _NotificationCaptureScreenState();
}

class _NotificationCaptureScreenState extends ConsumerState<NotificationCaptureScreen> {
  NotificationCaptureState? _state;
  var _busy = false;
  String? _error;
  late final AppLifecycleListener _lifecycle;
  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _refresh);
    Future.microtask(_refresh);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    if (!ref.read(notificationCaptureApiProvider).supported) return;
    try {
      final value = await ref.read(notificationCaptureApiProvider).status();
      if (mounted) {
        setState(() {
          _state = value;
          _error = null;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _error = 'Notification status could not be loaded. Your saved evidence was kept.');
    }
  }

  Future<void> _change(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
      await _refresh();
    } catch (_) {
      if (mounted) setState(() => _error = 'The change could not be saved. Retry; existing evidence was kept.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _configure(bool enabled, Set<String> packages) async {
    if (enabled) {
      // Finish foreground initialization before allowing a headless engine to open the ledger.
      await ref.read(databaseProvider).customSelect('SELECT count(*) FROM transactions').get();
    }
    await ref.read(notificationCaptureApiProvider).configure(enabled, packages);
  }

  @override
  Widget build(BuildContext context) => Theme(
    data: ledgerTheme(Theme.of(context).brightness),
    child: Builder(
      builder: (context) {
        final api = ref.watch(notificationCaptureApiProvider), s = _state;
        return Scaffold(
          appBar: AppBar(title: const Text('Notification capture')),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                  children: [
                    Text('Capture payment alerts', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    const Text(
                      'Android notification access lets Kankoo receive notifications from your phone. Only apps you select below are saved. Notification text is encrypted on this device before it is processed.',
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Capture starts after you enable it and grant access. Android may delay background work. Force-stopping Kankoo, hidden notification text or disabled bank alerts can prevent capture; reconcile against your bank statement.',
                    ),
                    if (!api.supported)
                      reviewNotice(
                        context,
                        'Automatic notification capture is available on Android. Use statement imports or manual entry on this device.',
                      ),
                    if (_error != null) reviewNotice(context, _error!, review: true),
                    if (api.supported && s == null && _error == null) const LinearProgressIndicator(),
                    if (s != null) ...[
                      const SizedBox(height: 20),
                      Text(
                        s.accessGranted ? 'Android access granted' : 'Android access not granted',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextButton(
                        onPressed: _busy ? null : () => _change(api.openSettings),
                        child: const Text('Open Android notification access'),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Capture selected apps'),
                        subtitle: const Text('Turning this off keeps records already captured.'),
                        value: s.enabled,
                        onChanged: _busy || s.packages.isEmpty ? null : (v) => _change(() => _configure(v, s.packages)),
                      ),
                      if (s.packages.isEmpty) const Text('Select at least one app to enable capture.'),
                      if (s.enabled && !s.accessGranted)
                        reviewNotice(
                          context,
                          'Capture is enabled in Kankoo, but Android access is missing. Grant access above to receive new alerts.',
                        ),
                      const SizedBox(height: 20),
                      Text('Apps to capture', style: Theme.of(context).textTheme.titleMedium),
                      const Text(
                        'Select only apps you use. A listed app is not a guarantee that its notification format can be parsed.',
                      ),
                      for (final entry in {
                        ...notificationApps,
                        for (final p in s.packages)
                          if (!notificationApps.containsKey(p)) p: p,
                      }.entries)
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(entry.value),
                          value: s.packages.contains(entry.key),
                          onChanged: _busy
                              ? null
                              : (on) {
                                  final selected = {...s.packages};
                                  if (on == true) {
                                    selected.add(entry.key);
                                  } else {
                                    selected.remove(entry.key);
                                  }
                                  _change(() => _configure(s.enabled && selected.isNotEmpty, selected));
                                },
                        ),
                      const SizedBox(height: 20),
                      Text('Processing status', style: Theme.of(context).textTheme.titleMedium),
                      Text('${s.pending} waiting · ${s.quarantined} unreadable records retained'),
                      if (s.lastProcessed != null)
                        Text('Last batch: ${DateFormat('d MMM yyyy, HH:mm').format(s.lastProcessed!)}'),
                      if (s.captureError)
                        reviewNotice(
                          context,
                          'An alert could not be saved. Check storage and access, then retry. Notifications missed before saving may require a statement import.',
                          review: true,
                        ),
                      if (s.processingError)
                        reviewNotice(
                          context,
                          'Processing was interrupted. Saved notifications remain encrypted and will be retried.',
                          review: true,
                        ),
                      if (s.quarantined > 0)
                        reviewNotice(
                          context,
                          'Some records could not be decrypted. Their encrypted bytes were kept. Retry after restoring access; no key is replaced.',
                          review: true,
                        ),
                      FilledButton(
                        onPressed: _busy || !s.enabled ? null : () => _change(api.retry),
                        child: const Text('Retry pending records'),
                      ),
                      TextButton(
                        onPressed: () => context.push('/messages?source=notification'),
                        child: const Text('Review parsed and unreadable alerts'),
                      ),
                    ],
                    if (api.supported)
                      TextButton(onPressed: _busy ? null : _refresh, child: const Text('Refresh status')),
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
