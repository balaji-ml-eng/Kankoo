import 'dart:io';

import 'package:background_downloader/background_downloader.dart' show FileDownloader;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/startup_gate.dart';
import 'ingestion/share/share_intake.dart';
import 'ingestion/notifications/notification_intake.dart';
import 'llm/on_device/on_device_client.dart';
import 'llm/on_device/on_device_initialization.dart';
import 'providers.dart';

void main() {
  debugPrint('[kankoo-startup] Dart entry reached');
  WidgetsFlutterBinding.ensureInitialized();
  // Before runApp: its route observer must precede the router's (iOS links).
  IncomingShares.instance.start();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(
    StartupGate(
      loadPreferences: () async {
        await waitForNotificationWorker();
        return SharedPreferences.getInstance();
      },
      afterReady: _initOnDeviceAi,
      builder: (prefs) => ProviderScope(overrides: [prefsProvider.overrideWithValue(prefs)], child: const KankooApp()),
    ),
  );
}

@pragma('vm:entry-point')
void notificationWorkerMain() => runNotificationWorker();

/// Registers the LiteRT-LM engine for on-device Gemma. A failure only
/// disables on-device AI; it must never stop the app from starting.
Future<void> _initOnDeviceAi() async {
  if (!Platform.isAndroid && !Platform.isIOS) return;
  try {
    await ensureOnDeviceInitialized();
    // Keeps a loaded model warm between questions; frees it when idle or on
    // memory pressure.
    OnDeviceClient.runtime.attach();
  } catch (e) {
    debugPrint('[kankoo-startup] on-device AI unavailable (${e.runtimeType})');
  }
  try {
    // Model downloads start only from Settings, so a download WorkManager
    // revived after the app was killed is an orphan: stop it before it
    // quietly continues (possibly on mobile data).
    await FileDownloader().cancelAll(group: 'smart_downloads').timeout(const Duration(seconds: 5));
  } catch (e) {
    debugPrint('[kankoo-startup] download cleanup unavailable (${e.runtimeType})');
  }
}
