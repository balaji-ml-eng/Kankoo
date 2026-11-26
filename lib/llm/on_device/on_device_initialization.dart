import 'dart:async';
import 'dart:io';

import 'package:flutter_edge_ai/flutter_edge_ai.dart';
import 'package:flutter_edge_ai_litertlm/flutter_edge_ai_litertlm.dart';

Future<void>? _initialization;

/// Share one initialization with AI settings/clients. A timeout doesn't cancel
/// native work, so retain that future rather than starting competing retries.
Future<void> ensureOnDeviceInitialized() {
  if (!Platform.isAndroid && !Platform.isIOS) return Future.value();
  final pending = _initialization ??= _initialize();
  return pending.timeout(
    const Duration(seconds: 15),
    onTimeout: () {
      throw TimeoutException('On-device AI is taking too long to start. The rest of Kankoo is available.');
    },
  );
}

Future<void> _initialize() async {
  try {
    await FlutterEdgeAi.initialize(inferenceEngines: [const LiteRtLmEngine()]);
  } catch (_) {
    _initialization = null;
    rethrow;
  }
}
