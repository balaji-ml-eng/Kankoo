import 'dart:async';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kankoo/core/security/app_lock.dart';
import 'package:kankoo/data/db/database.dart';
import 'package:kankoo/exports/ca_bundle.dart';
import 'package:kankoo/features/exports/ca_export_providers.dart';
import 'package:kankoo/features/exports/ca_export_screen.dart';
import 'package:kankoo/ui/ledger_theme.dart';

import 'statement_import_screen_test.dart' show capture;

class _Lock extends AppLockController {
  _Lock(this.locked);
  final bool locked;
  @override
  AppLockState build() => AppLockState(enabled: locked, locked: locked);
}

class _Exports extends CaExportService {
  _Exports(super.db) : super(readPdf: (_) async => Uint8List(0));
  Object? error;
  Completer<void>? pending;
  int calls = 0;
  @override
  Future<CaBundle> create(DateTime month) async {
    calls++;
    await pending?.future;
    if (error != null) throw error!;
    return CaBundle(
      7,
      'kankoo-ca-2026-11-export-7.zip',
      Uint8List.fromList([1, 2, 3]),
      'a' * 64,
      const CaPreview(12, 3, 2, 1, 1, 4),
    );
  }
}

void main() {
  final month = DateTime(2026, 11);
  late AppDatabase db;
  late _Exports service;
  var saves = 0;
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    service = _Exports(db);
    saves = 0;
  });
  tearDown(() => db.close());
  setUpAll(() async {
    final sdk = Platform.environment['FLUTTER_ROOT'];
    if (sdk != null && Platform.environment['KANKOO_VISUAL_DIR'] != null) {
      for (final entry in {'Roboto': 'roboto-regular.ttf', 'MaterialIcons': 'materialicons-regular.otf'}.entries) {
        await (FontLoader(entry.key)..addFont(
              Future.value(
                ByteData.sublistView(
                  await File('$sdk/bin/cache/artifacts/material_fonts/${entry.value}').readAsBytes(),
                ),
              ),
            ))
            .load();
      }
    }
  });
  Future<void> mount(
    WidgetTester tester, {
    bool saved = true,
    bool locked = false,
    bool dark = false,
    Size size = const Size(390, 844),
    double scale = 1,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          caExportServiceProvider.overrideWithValue(service),
          caExportPreviewProvider(month).overrideWith((_) async => const CaPreview(12, 3, 2, 1, 1, 4)),
          caExportHistoryProvider(month).overrideWith(
            (_) => Stream.value([
              ExportRun(
                id: 6,
                periodStart: month,
                periodEnd: DateTime(2026, 12),
                formatVersion: 1,
                includedCount: 12,
                manifestSha256: 'a' * 64,
                createdAt: DateTime(2026, 11, 26, 12),
              ),
            ]),
          ),
          appLockProvider.overrideWith(() => _Lock(locked)),
          caBundleSaverProvider.overrideWithValue((name, bytes) async {
            saves++;
            expect(name, endsWith('.zip'));
            expect(bytes, [1, 2, 3]);
            return saved;
          }),
        ],
        child: RepaintBoundary(
          key: const ValueKey('capture'),
          child: MaterialApp(
            theme: ledgerTheme(dark ? Brightness.dark : Brightness.light),
            home: CaExportScreen(month: month),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> save(WidgetTester tester) async {
    await tester.scrollUntilVisible(find.text('Save CA bundle (ZIP)'), 250, scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save CA bundle (ZIP)'));
    await tester.pumpAndSettle();
  }

  testWidgets('saves the verified ZIP and describes readable contents honestly', (tester) async {
    await mount(tester);
    expect(find.text('November 2026'), findsOneWidget);
    expect(find.textContaining('readable financial records'), findsOneWidget);
    await capture(tester, 'ca-export-phone-light');
    await save(tester);
    expect(saves, 1);
    expect(service.calls, 1);
    expect(find.text('Saved kankoo-ca-2026-11-export-7.zip. 4 original PDFs verified.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('cancel does not claim saved; failed generation can be retried', (tester) async {
    service.error = const CaExportException('Invoice PDF failed its integrity check.');
    await mount(tester, saved: false);
    await save(tester);
    expect(saves, 0);
    expect(find.text('Invoice PDF failed its integrity check.'), findsOneWidget);
    service.error = null;
    await save(tester);
    expect(saves, 1);
    expect(find.textContaining('Save cancelled.'), findsOneWidget);
    expect(find.textContaining('no saved file is claimed'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('locked app cannot send financial bytes to the picker', (tester) async {
    await mount(tester, locked: true);
    await save(tester);
    expect(saves, 0);
    expect(find.textContaining('Open and unlock Kankoo'), findsOneWidget);
  });
  testWidgets('generation disables duplicate exports until complete', (tester) async {
    service.pending = Completer<void>();
    await mount(tester);
    await tester.ensureVisible(find.text('Save CA bundle (ZIP)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save CA bundle (ZIP)'));
    await tester.pump();
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNull);
    expect(service.calls, 1);
    service.pending!.complete();
    await tester.pumpAndSettle();
    expect(saves, 1);
  });
  for (final dark in [false, true]) {
    testWidgets('320px at 150% text has reachable controls (${dark ? 'dark' : 'light'})', (tester) async {
      await mount(tester, dark: dark, size: const Size(320, 740), scale: 1.5);
      await capture(tester, 'ca-export-small-${dark ? 'dark' : 'light'}');
      await save(tester);
      expect(saves, 1);
      await tester.scrollUntilVisible(
        find.text('Copy manifest SHA-256'),
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await capture(tester, 'ca-export-history-${dark ? 'dark' : 'light'}');
      expect(tester.takeException(), isNull);
    });
  }
}
