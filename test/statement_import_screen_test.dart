import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kankoo/data/db/database.dart';
import 'package:kankoo/features/imports/statement_import_providers.dart';
import 'package:kankoo/features/imports/statement_import_screen.dart';
import 'package:kankoo/providers.dart';
import 'package:kankoo/ui/ledger_theme.dart';

import 'statement_import_test.dart' show bankCsv, request;

import 'package:kankoo/ingestion/statements/statement_csv.dart';

Future<void> flush(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
  }
}

Future<void> capture(WidgetTester tester, String name) async {
  final dir = Platform.environment['KANKOO_VISUAL_DIR'];
  if (dir == null) return;
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(const ValueKey('capture')));
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    await Directory(dir).create(recursive: true);
    await File('$dir/$name.png').writeAsBytes(data!.buffer.asUint8List());
    image.dispose();
  });
}

void main() {
  setUpAll(() async {
    final sdk = Platform.environment['FLUTTER_ROOT'];
    if (sdk != null && Platform.environment['KANKOO_VISUAL_DIR'] != null) {
      final font = File('$sdk/bin/cache/artifacts/material_fonts/roboto-regular.ttf');
      final loader = FontLoader('Roboto')..addFont(Future.value(ByteData.sublistView(await font.readAsBytes())));
      await loader.load();
      final icons = FontLoader('MaterialIcons')
        ..addFont(
          Future.value(
            ByteData.sublistView(
              await File('$sdk/bin/cache/artifacts/material_fonts/materialicons-regular.otf').readAsBytes(),
            ),
          ),
        );
      await icons.load();
    }
  });

  testWidgets('phone workflow blocks mismatch, imports balanced rows, then blocks duplicate', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final db = AppDatabase(NativeDatabase.memory());
    await tester.runAsync(() => db.addAccount(name: 'Agency current account', kind: AccountKind.bank, color: 1));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          csvPickerProvider.overrideWithValue(() async => ImportFile('november-2026.csv', utf8.encode(bankCsv))),
        ],
        child: RepaintBoundary(
          key: const ValueKey('capture'),
          child: MaterialApp(home: const StatementImportScreen()),
        ),
      ),
    );
    await flush(tester);
    await capture(tester, 'import-phone-start');
    await tester.tap(find.text('Choose CSV'));
    await flush(tester);
    await flush(tester);
    expect(find.text('Map your columns'), findsOneWidget);
    final opening = find.byKey(const ValueKey('opening-balance'));
    final closing = find.byKey(const ValueKey('closing-balance'));
    await tester.ensureVisible(opening);
    await tester.enterText(opening, '10000');
    await tester.enterText(closing, '10821');
    await flush(tester);
    final button = find.widgetWithText(FilledButton, 'Import 3 reconciled transactions');
    expect(tester.widget<FilledButton>(button).onPressed, isNull);
    await tester.ensureVisible(find.byType(ReconciliationPreviewCard));
    await tester.pumpAndSettle();
    await capture(tester, 'import-phone-mismatch');
    await tester.ensureVisible(closing);
    await tester.enterText(closing, '10820');
    await flush(tester);
    expect(tester.widget<FilledButton>(button).onPressed, isNotNull);
    await tester.ensureVisible(find.byType(ReconciliationPreviewCard));
    await tester.pumpAndSettle();
    await capture(tester, 'import-phone-reconciled');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await flush(tester);
    await flush(tester);
    expect(find.text('Statement imported'), findsOneWidget);
    await tester.ensureVisible(find.text('Import another statement'));
    await tester.tap(find.text('Import another statement'));
    await flush(tester);
    await flush(tester);
    expect(tester.widget<FilledButton>(button).onPressed, isNull);
    expect(tester.takeException(), isNull);
    tester.view.physicalSize = const Size(320, 760);
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    final closed = db.close();
    await flush(tester);
    await tester.runAsync(() => closed);
  });

  for (final dark in [false, true]) {
    testWidgets('reconciliation fits narrow phone with large text ${dark ? 'dark' : 'light'}', (tester) async {
      tester.view.physicalSize = const Size(320, 760);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        RepaintBoundary(
          key: const ValueKey('capture'),
          child: MaterialApp(
            theme: ledgerTheme(dark ? Brightness.dark : Brightness.light),
            home: Builder(
              builder: (context) => MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.5)),
                child: Scaffold(
                  body: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: ReconciliationPreviewCard(preview: buildStatementPreview(request())),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await capture(tester, 'reconcile-large-text-${dark ? 'dark' : 'light'}');
    });
  }
}
