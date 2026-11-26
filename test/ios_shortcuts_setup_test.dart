import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kankoo/app.dart';
import 'package:kankoo/data/db/database.dart';
import 'package:kankoo/features/settings/shortcuts_screen.dart';
import 'package:kankoo/ingestion/share/share_intake.dart';
import 'package:kankoo/ingestion/share/shortcuts_inbox.dart';
import 'package:kankoo/ingestion/sms/sms_source.dart';
import 'package:kankoo/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupInbox extends ShortcutsInbox {
  bool enabled = false;
  bool fail = false;
  @override
  bool get isSupported => true;
  @override
  Future<ShortcutsStatus> status() async => ShortcutsStatus(enabled: enabled, pendingCount: 0);
  @override
  Future<void> setEnabled(bool value) async {
    if (fail) throw StateError('simulated keychain failure');
    enabled = value;
  }

  @override
  Future<ShortcutBatch> pending() async => const ShortcutBatch([], 0, 0);
}

void main() {
  Future<ProviderContainer> show(WidgetTester tester, SetupInbox inbox, {bool onboarding = false}) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({PrefKeys.onboarded: !onboarding});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final container = ProviderContainer(
      overrides: [
        prefsProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(db),
        shortcutsInboxProvider.overrideWithValue(inbox),
        incomingSharesProvider.overrideWithValue(IncomingShares.testing(inbox)),
        smsSourceProvider.overrideWithValue(SmsSource()),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: onboarding
            ? const KankooApp()
            : MaterialApp(
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.5)),
                  child: child!,
                ),
                home: const ShortcutsScreen(),
              ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('iPhone onboarding reaches native setup without requesting SMS permission', (tester) async {
    final container = await show(tester, SetupInbox(), onboarding: true);
    expect(find.text('Allow SMS and import'), findsNothing);
    final button = find.text('Set up iPhone Shortcuts');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(container.read(onboardedProvider), true);
    expect(find.text('Allow Shortcuts forwarding'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('small phone and large text keep toggle and setup steps reachable', (tester) async {
    final inbox = SetupInbox();
    await show(tester, inbox);
    await tester.scrollUntilVisible(find.byType(SwitchListTile), 180);
    await tester.ensureVisible(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(inbox.enabled, true);
    expect(tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value, true);
    await tester.scrollUntilVisible(find.text('What to expect'), 400);
    expect(tester.takeException(), isNull);
  });

  testWidgets('failed enable stays off and permits retry', (tester) async {
    final inbox = SetupInbox()..fail = true;
    await show(tester, inbox);
    await tester.scrollUntilVisible(find.byType(SwitchListTile), 180);
    await tester.ensureVisible(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(inbox.enabled, false);
    expect(find.textContaining('existing encrypted inbox has been kept'), findsOneWidget);
    inbox.fail = false;
    await tester.scrollUntilVisible(find.byType(SwitchListTile), 180);
    await tester.ensureVisible(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(inbox.enabled, true);
    expect(tester.takeException(), isNull);
  });
}
