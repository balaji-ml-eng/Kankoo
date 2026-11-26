import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kankoo/data/db/database.dart';
import 'package:kankoo/features/settings/notification_capture_screen.dart';
import 'package:kankoo/providers.dart';
import 'package:kankoo/ui/ledger_theme.dart';

import 'statement_import_screen_test.dart' show capture, flush;

class _Api extends NotificationCaptureApi {
  bool isSupported = true, failConfigure = false;
  int requests = 0, retries = 0;
  NotificationCaptureState value = const NotificationCaptureState();
  @override
  bool get supported => isSupported;
  @override
  Future<NotificationCaptureState> status() async => value;
  @override
  Future<void> configure(bool enabled, Set<String> packages) async {
    if (failConfigure) throw StateError('Storage unavailable');
    value = NotificationCaptureState(enabled: enabled, packages: packages, accessGranted: value.accessGranted);
  }

  @override
  Future<void> openSettings() async {
    requests++;
  }

  @override
  Future<void> retry() async {
    retries++;
  }
}

void main() {
  late AppDatabase db;
  late _Api api;
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    api = _Api();
  });
  tearDown(() => db.close());
  setUpAll(() async {
    final sdk = Platform.environment['FLUTTER_ROOT'];
    if (sdk != null && Platform.environment['KANKOO_VISUAL_DIR'] != null) {
      for (final e in {'Roboto': 'roboto-regular.ttf', 'MaterialIcons': 'materialicons-regular.otf'}.entries) {
        await (FontLoader(e.key)..addFont(
              Future.value(
                ByteData.sublistView(await File('$sdk/bin/cache/artifacts/material_fonts/${e.value}').readAsBytes()),
              ),
            ))
            .load();
      }
    }
  });
  Future<void> mount(WidgetTester tester, {bool dark = false, double scale = 1, double width = 390}) async {
    tester.view.physicalSize = Size(width, 844);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.runAsync(() => db.customSelect('SELECT count(*) FROM transactions').get());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db), notificationCaptureApiProvider.overrideWithValue(api)],
        child: RepaintBoundary(
          key: const ValueKey('capture'),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ledgerTheme(dark ? Brightness.dark : Brightness.light),
            home: const NotificationCaptureScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, String text) async {
    await tester.scrollUntilVisible(find.text(text), 250, scrollable: find.byType(Scrollable).first);
    await Scrollable.ensureVisible(tester.element(find.text(text)), alignment: 0.5);
    await tester.pumpAndSettle();
    await tester.tap(find.text(text));
    await flush(tester);
  }

  testWidgets('capture requires app selection, initializes ledger, and distinguishes missing Android access', (
    tester,
  ) async {
    await mount(tester);
    expect(tester.widget<SwitchListTile>(find.byType(SwitchListTile)).onChanged, isNull);
    expect(api.requests, 0);
    await capture(tester, 'notification-setup-light');
    await tap(tester, 'PhonePe');
    await tap(tester, 'Capture selected apps');
    expect(api.value.enabled, isTrue);
    expect(api.value.packages, {'com.phonepe.app'});
    expect(find.textContaining('Android access is missing'), findsOneWidget);
    await tap(tester, 'Open Android notification access');
    expect(api.requests, 1);
    expect(tester.takeException(), isNull);
  });
  testWidgets('failed toggle preserves last state and reports error', (tester) async {
    api.value = const NotificationCaptureState(enabled: true, accessGranted: true, packages: {'com.phonepe.app'});
    api.failConfigure = true;
    await mount(tester);
    await tap(tester, 'Capture selected apps');
    expect(api.value.enabled, isTrue);
    await tester.scrollUntilVisible(
      find.textContaining('change could not be saved'),
      -250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('change could not be saved'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('non-Android does not offer automatic capture', (tester) async {
    api.isSupported = false;
    await mount(tester);
    expect(find.textContaining('available on Android'), findsOneWidget);
    expect(find.byType(SwitchListTile), findsNothing);
  });
  for (final dark in [false, true]) {
    testWidgets('queue errors and retry remain accessible at 320px 150% (${dark ? 'dark' : 'light'})', (tester) async {
      api.value = const NotificationCaptureState(
        enabled: true,
        accessGranted: true,
        packages: {'com.phonepe.app'},
        pending: 2,
        quarantined: 1,
        captureError: true,
        processingError: true,
      );
      await mount(tester, width: 320, scale: 1.5, dark: dark);
      await capture(tester, 'notification-small-${dark ? 'dark' : 'light'}');
      await tap(tester, 'Retry pending records');
      expect(api.retries, 1);
      await capture(tester, 'notification-errors-${dark ? 'dark' : 'light'}');
      expect(find.textContaining('encrypted bytes were kept'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
