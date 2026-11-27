import 'dart:io';

import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kankoo/app.dart';
import 'package:kankoo/core/theme/app_theme.dart';
import 'package:kankoo/data/db/database.dart';
import 'package:kankoo/features/reconciliation/reconciliation_providers.dart';
import 'package:kankoo/features/reconciliation/reconciliation_widgets.dart';
import 'package:kankoo/ingestion/sms/sms_source.dart';
import 'package:kankoo/providers.dart';
import 'package:kankoo/reconciliation/reconciliation_service.dart';
import 'package:kankoo/tax_checks/invoice_validation.dart';
import 'package:kankoo/ui/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'statement_import_screen_test.dart' show capture, flush;

final designMonth = DateTime(2026, 11);

class _Month extends SelectedMonth {
  @override
  DateTime build() => designMonth;
}

class _Sms extends SmsSource {
  int requests = 0;
  @override
  bool get isSupported => true;
  @override
  Future<bool> requestPermission() async {
    requests++;
    return false;
  }
}

void main() {
  void designTest(String name, WidgetTesterCallback body) {
    testWidgets(name, (tester) async {
      try {
        await body(tester);
      } finally {
        await tester.pumpWidget(const SizedBox.shrink());
        await flush(tester);
      }
    });
  }

  late AppDatabase db;
  late ReconciliationService service;
  late SharedPreferences prefs;
  late _Sms sms;
  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    service = ReconciliationService(db, verifyDocument: (_) async {});
    sms = _Sms();
  });
  tearDown(() => db.close());
  setUpAll(() async {
    if (Platform.environment['KANKOO_VISUAL_DIR'] == null) return;
    final sdk = Platform.environment['FLUTTER_ROOT']!;
    final cache = Platform.environment['PUB_CACHE']!;
    final fonts = {
      'Roboto': '$sdk/bin/cache/artifacts/material_fonts/roboto-regular.ttf',
      'MaterialIcons': '$sdk/bin/cache/artifacts/material_fonts/materialicons-regular.otf',
      for (final e in {
        'PhosphorRegular': 'Phosphor.ttf',
        'PhosphorFill': 'Phosphor-Fill.ttf',
        'PhosphorBold': 'Phosphor-Bold.ttf',
      }.entries)
        'packages/phosphor_flutter/${e.key}': '$cache/hosted/pub.dev/phosphor_flutter-2.1.0/lib/fonts/${e.value}',
    };
    for (final font in fonts.entries) {
      await (FontLoader(
        font.key,
      )..addFont(Future.value(ByteData.sublistView(await File(font.value).readAsBytes())))).load();
    }
  });
  Future<void> seed(WidgetTester tester, {bool empty = false}) async {
    await tester.runAsync(() async {
      SharedPreferences.setMockInitialValues({'onboarded': true, 'currency.home': 'INR'});
      prefs = await SharedPreferences.getInstance();
      if (empty) return;
      Future<int> payment(int amount, String merchant) => db.addManual(
        amountMinor: amount,
        direction: TxnDirection.debit,
        at: DateTime(2026, 11, 12),
        merchant: merchant,
      );
      final first = await payment(72000, 'Amazon Web Services');
      await (db.update(
        db.transactions,
      )..where((t) => t.id.equals(first))).write(const TransactionsCompanion(status: Value(TxnStatus.needsReview)));
      await service.classify(await payment(118000, 'Studio workspace'), 10000);
      await service.classify(await payment(79900, 'Personal grocery'), 0);
      final matched = await payment(100000, 'Design software');
      await service.classify(matched, 10000);
      final document = await db
          .into(db.documents)
          .insert(
            DocumentsCompanion.insert(
              sha256: 'a' * 64,
              encryptedFilePath: '${'a' * 64}.kpdf',
              originalName: 'design-software.pdf',
              byteLength: 100,
            ),
          );
      final invoice = await service.saveInvoice(
        InvoiceDraft(
          documentId: document,
          vendor: 'Design software',
          number: 'NOV-2026-12',
          date: designMonth,
          amounts: const InvoiceAmounts(taxable: 100000, total: 100000),
        ),
      );
      await service.link(matched, invoice, 100000);
      await db.addManual(
        amountMinor: 4999,
        currency: 'USD',
        direction: TxnDirection.debit,
        at: DateTime(2026, 11, 13),
        merchant: 'Overseas service',
      );
    });
  }

  Future<void> mount(WidgetTester tester, {bool dark = false, double width = 390, double scale = 1}) async {
    tester.view.physicalSize = Size(width, 844);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await prefs.setInt('themeMode', dark ? ThemeMode.dark.index : ThemeMode.light.index);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          prefsProvider.overrideWithValue(prefs),
          smsSourceProvider.overrideWithValue(sms),
          selectedMonthProvider.overrideWith(_Month.new),
          reconciliationServiceProvider.overrideWithValue(service),
        ],
        child: const RepaintBoundary(key: ValueKey('capture'), child: KankooApp()),
      ),
    );
    await flush(tester);
  }

  Future<void> tap(WidgetTester tester, String text) async {
    await tester.scrollUntilVisible(find.text(text), 250, scrollable: find.byType(Scrollable).first);
    await Scrollable.ensureVisible(tester.element(find.text(text)), alignment: 0.5);
    await tester.pumpAndSettle();
    await tester.tap(find.text(text));
    await flush(tester);
  }

  designTest('home reflects real review counts and routes directly to bank checks', (tester) async {
    await seed(tester);
    await mount(tester);
    expect(find.text('3 of 4 INR payments classified. Self-transfers excluded.'), findsOneWidget);
    expect(find.text('₹2,180.00'), findsOneWidget);
    expect(find.text('1 still to review'), findsOneWidget);
    expect(find.text('1 business payment needs attention'), findsOneWidget);
    await capture(tester, 'home-light');
    await tap(tester, 'Check bank details');
    expect(find.text('Amazon Web Services'), findsOneWidget);
    expect(find.text('Studio workspace'), findsNothing);
    await capture(tester, 'books-bank-checks-light');
    expect(tester.takeException(), isNull);
  });
  designTest('empty home sends founders to the verified statement importer', (tester) async {
    await seed(tester, empty: true);
    await mount(tester);
    await capture(tester, 'home-empty-light');
    await tap(tester, 'Import your first statement');
    expect(find.text('Statements & evidence'), findsOneWidget);
    expect(sms.requests, 0);
    expect(tester.takeException(), isNull);
  });
  designTest('onboarding offers CSV first without requesting SMS access', (tester) async {
    await seed(tester, empty: true);
    await prefs.setBool('onboarded', false);
    await mount(tester);
    expect(find.text('Start with a bank CSV'), findsOneWidget);
    expect(find.text('Allow SMS and import'), findsNothing);
    await capture(tester, 'onboarding-light');
    await tap(tester, 'Start with a bank CSV');
    expect(find.text('Statements & evidence'), findsOneWidget);
    expect(prefs.getBool('onboarded'), isTrue);
    expect(sms.requests, 0);
    expect(tester.takeException(), isNull);
  });
  designTest('Books is a primary tab and preserves access to the evidence workspace', (tester) async {
    await seed(tester);
    await mount(tester);
    await tester.tap(find.text('Books'));
    await flush(tester);
    expect(find.text('Monthly books'), findsOneWidget);
    expect(find.text('Amazon Web Services'), findsOneWidget);
    await capture(tester, 'books-light');
    expect(tester.takeException(), isNull);
  });
  designTest('home task links update an already-open Books tab', (tester) async {
    await seed(tester);
    await mount(tester);
    await tester.tap(find.text('Books'));
    await flush(tester);
    expect(find.text('Amazon Web Services'), findsOneWidget);
    await tester.tap(find.text('Home'));
    await flush(tester);
    await tap(tester, 'Complete the evidence');
    expect(find.text('Studio workspace'), findsOneWidget);
    expect(find.text('Amazon Web Services'), findsNothing);
    expect(tester.takeException(), isNull);
  });
  for (final dark in [false, true]) {
    designTest('secondary screens fit the shared theme at 320px 150% (${dark ? 'dark' : 'light'})', (tester) async {
      await seed(tester);
      await mount(tester, dark: dark, width: 320, scale: 1.5);
      await tester.tap(find.text('Activity'));
      await flush(tester);
      await capture(tester, 'activity-small-${dark ? 'dark' : 'light'}');
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Settings'));
      await flush(tester);
      await capture(tester, 'settings-small-${dark ? 'dark' : 'light'}');
      expect(tester.takeException(), isNull);
      await tap(tester, 'Spending insights');
      await capture(tester, 'insights-small-${dark ? 'dark' : 'light'}');
      expect(tester.takeException(), isNull);
      await tester.pageBack();
      await flush(tester);
      await tester.tap(find.text('Ask'));
      await flush(tester);
      await capture(tester, 'ask-small-${dark ? 'dark' : 'light'}');
      expect(tester.takeException(), isNull);
    });
    designTest('founder home and Books fit 320px at 150% (${dark ? 'dark' : 'light'})', (tester) async {
      await seed(tester);
      await mount(tester, dark: dark, width: 320, scale: 1.5);
      await capture(tester, 'home-small-${dark ? 'dark' : 'light'}');
      await tester.tap(find.text('Books'));
      await flush(tester);
      await capture(tester, 'books-small-${dark ? 'dark' : 'light'}');
      expect(tester.takeException(), isNull);
    });
  }
  designTest('large-text payment rows retain exact rupees and do not overflow', (tester) async {
    await seed(tester);
    final id = await tester.runAsync(
      () => db.addManual(
        amountMinor: 123456789,
        direction: TxnDirection.debit,
        at: designMonth,
        merchant: 'Long vendor name for a consulting business',
      ),
    );
    final view = await tester.runAsync(() => db.watchTxn(id!).first);
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: TransactionTile(view: view!),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('−₹12,34,567.89'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  for (final dark in [false, true]) {
    designTest('evidence status text meets 4.5:1 contrast (${dark ? 'dark' : 'light'})', (tester) async {
      final theme = dark ? AppTheme.dark() : AppTheme.light();
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: Builder(
              builder: (context) => Column(
                children: [
                  for (final status in ['Unreviewed', 'Needs Evidence', 'Evidence Matched', 'Mismatch'])
                    evidenceBadge(context, status),
                ],
              ),
            ),
          ),
        ),
      );
      for (final status in ['Unreviewed', 'Needs Evidence', 'Evidence Matched', 'Mismatch']) {
        final label = tester.widget<Text>(find.text(status));
        final container = tester.widget<Container>(
          find.ancestor(of: find.text(status), matching: find.byType(Container)).first,
        );
        final background = Color.alphaBlend(
          (container.decoration as BoxDecoration).color!,
          theme.scaffoldBackgroundColor,
        );
        final a = label.style!.color!.computeLuminance(), b = background.computeLuminance();
        expect((a > b ? (a + 0.05) / (b + 0.05) : (b + 0.05) / (a + 0.05)), greaterThanOrEqualTo(4.5), reason: status);
      }
    });
  }
}
