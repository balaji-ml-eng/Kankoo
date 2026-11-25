import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kankoo/data/db/database.dart';
import 'package:kankoo/features/onboarding/onboarding_screen.dart';
import 'package:kankoo/ingestion/parser/parsed_txn.dart';
import 'package:kankoo/ingestion/sms/sms_source.dart';
import 'package:kankoo/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestSms extends SmsSource {
  bool allowed = false;
  bool fail = false;
  bool notificationsFail = false;
  int settingsOpened = 0;
  @override
  bool get isSupported => true;
  @override
  Future<bool> hasPermission() async => allowed;
  @override
  Future<bool> requestPermission() async {
    if (fail) throw StateError('permission service unavailable');
    return allowed;
  }

  @override
  Future<void> requestNotifications() async {
    if (notificationsFail) throw StateError('notifications unavailable');
  }

  @override
  Future<void> openSettings() async {
    settingsOpened++;
  }

  @override
  Future<List<RawInput>> readSince(DateTime since, {int limit = 1000}) async => [];
}

void main() {
  Future<ProviderContainer> show(WidgetTester tester, TestSms sms) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final c = ProviderContainer(
      overrides: [
        prefsProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(db),
        smsSourceProvider.overrideWithValue(sms),
      ],
    );
    addTearDown(c.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        child: MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.5)),
            child: child!,
          ),
          home: const OnboardingScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return c;
  }

  testWidgets('small phone and large text keep SMS and skip buttons reachable', (tester) async {
    final c = await show(tester, TestSms());
    expect(tester.takeException(), isNull);
    final button = find.text('Allow SMS and import');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(c.read(onboardedProvider), isFalse);
    expect(find.textContaining('SMS permission was denied'), findsOneWidget);
    final settings = find.text('Open app permissions');
    await tester.ensureVisible(settings);
    await tester.tap(settings);
    await tester.pumpAndSettle();
    final skip = find.text('Skip for now');
    await tester.ensureVisible(skip);
    await tester.tap(skip);
    await tester.pumpAndSettle();
    expect(c.read(onboardedProvider), isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('permission errors release busy state so connection can be retried', (tester) async {
    final sms = TestSms()..fail = true;
    final c = await show(tester, sms);
    await tester.ensureVisible(find.text('Allow SMS and import'));
    await tester.tap(find.text('Allow SMS and import'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Could not connect SMS'), findsOneWidget);
    sms
      ..fail = false
      ..allowed = true
      ..notificationsFail = true;
    await tester.ensureVisible(find.text('Allow SMS and import'));
    await tester.tap(find.text('Allow SMS and import'));
    await tester.pumpAndSettle();
    expect(c.read(onboardedProvider), isTrue);
    expect(tester.takeException(), isNull);
  });
}
