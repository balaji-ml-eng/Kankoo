import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Paint before waiting for plugins. Saved settings remain mandatory so a
/// settings failure cannot bypass an existing app lock or reset preferences.
class StartupGate extends StatefulWidget {
  const StartupGate({
    super.key,
    required this.loadPreferences,
    required this.builder,
    this.afterReady,
    this.preferencesTimeout = const Duration(seconds: 10),
  });
  final Future<SharedPreferences> Function() loadPreferences;
  final Widget Function(SharedPreferences) builder;
  final Future<void> Function()? afterReady;
  final Duration preferencesTimeout;
  @override
  State<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<StartupGate> {
  SharedPreferences? _preferences;
  bool _failed = false;
  int _attempt = 0;
  @override
  void initState() {
    super.initState();
    unawaited(_load());
    WidgetsBinding.instance.addPostFrameCallback((_) => debugPrint('[kankoo-startup] first frame painted'));
  }

  Future<void> _load() async {
    final attempt = ++_attempt;
    setState(() => _failed = false);
    debugPrint('[kankoo-startup] loading saved settings');
    try {
      final preferences = await widget.loadPreferences().timeout(widget.preferencesTimeout);
      if (!mounted || attempt != _attempt) return;
      setState(() => _preferences = preferences);
      debugPrint('[kankoo-startup] saved settings ready');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && attempt == _attempt) unawaited(_optionalServices());
      });
    } catch (error) {
      debugPrint('[kankoo-startup] saved settings unavailable (${error.runtimeType})');
      if (mounted && attempt == _attempt) setState(() => _failed = true);
    }
  }

  Future<void> _optionalServices() async {
    try {
      await widget.afterReady?.call();
    } catch (error) {
      debugPrint('[kankoo-startup] optional services unavailable (${error.runtimeType})');
    }
  }

  @override
  Widget build(BuildContext context) {
    final preferences = _preferences;
    if (preferences != null) return widget.builder(preferences);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_failed) const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(
                    _failed ? 'Kankoo couldn’t open its saved settings.' : 'Opening Kankoo…',
                    textAlign: TextAlign.center,
                  ),
                  if (_failed) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Your data has not been changed. Retry, or close and reopen the app.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    FilledButton(onPressed: _load, child: const Text('Retry')),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
