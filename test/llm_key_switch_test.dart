import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kankoo/core/secrets.dart';
import 'package:kankoo/features/settings/llm_settings_screen.dart';
import 'package:kankoo/llm/llm_config.dart';
import 'package:kankoo/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DelayedSecrets extends SecretStore {
  final reads = <String, Completer<String?>>{};
  @override
  Future<String?> read(String key) => (reads[key] ??= Completer<String?>()).future;
}

void main() {
  testWidgets('late previous-provider key never appears in the current provider', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final secrets = DelayedSecrets();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [prefsProvider.overrideWithValue(prefs), secretStoreProvider.overrideWithValue(secrets)],
        child: const MaterialApp(home: LlmSettingsScreen()),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('Anthropic Claude'));
    await tester.pump();
    secrets.reads[LlmConfig.keyName('anthropic')]!.complete('anthropic-test-key');
    await tester.pump();
    secrets.reads[LlmConfig.keyName('openai')]!.complete('openai-test-key');
    await tester.pump();
    await tester.ensureVisible(find.byType(TextField).first);
    final keyField = tester.widget<TextField>(find.byType(TextField).first);
    expect(keyField.controller!.text, 'anthropic-test-key');
    expect(tester.takeException(), isNull);
  });
}
