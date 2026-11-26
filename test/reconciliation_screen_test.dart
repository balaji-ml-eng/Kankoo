import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kankoo/data/db/database.dart';
import 'package:kankoo/features/reconciliation/evidence_sheet.dart';
import 'package:kankoo/features/reconciliation/invoice_editor.dart';
import 'package:kankoo/features/reconciliation/reconciliation_providers.dart';
import 'package:kankoo/features/reconciliation/reconciliation_screen.dart';
import 'package:kankoo/providers.dart';
import 'package:kankoo/reconciliation/reconciliation_service.dart';
import 'package:kankoo/tax_checks/invoice_validation.dart';
import 'package:kankoo/ui/ledger_theme.dart';

import 'statement_import_screen_test.dart' show flush, capture;

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.pump();
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
}

void main() {
  final month = DateTime(2026, 11);
  late AppDatabase db;
  late ReconciliationService service;
  late int paymentId;
  late Document document;
  setUpAll(() async {
    final sdk = Platform.environment['FLUTTER_ROOT'];
    if (sdk != null && Platform.environment['KANKOO_VISUAL_DIR'] != null) {
      for (final entry in {'Roboto': 'roboto-regular.ttf', 'MaterialIcons': 'materialicons-regular.otf'}.entries) {
        final font = FontLoader(entry.key)
          ..addFont(
            Future.value(
              ByteData.sublistView(await File('$sdk/bin/cache/artifacts/material_fonts/${entry.value}').readAsBytes()),
            ),
          );
        await font.load();
      }
    }
  });
  Future<void> seed(WidgetTester tester, {bool invoice = true}) async {
    await tester.runAsync(() async {
      db = AppDatabase(NativeDatabase.memory());
      service = ReconciliationService(db, verifyDocument: (_) async {});
      paymentId = await db.addManual(
        amountMinor: 118000,
        direction: TxnDirection.debit,
        merchant: 'AWS India',
        at: DateTime(2026, 11, 2),
      );
      final hash = 'a' * 64;
      await db
          .into(db.documents)
          .insert(
            DocumentsCompanion.insert(
              sha256: hash,
              encryptedFilePath: '$hash.kpdf',
              originalName: 'aws-november.pdf',
              byteLength: 100,
            ),
          );
      document = await db.select(db.documents).getSingle();
      if (invoice) {
        await service.saveInvoice(
          InvoiceDraft(
            documentId: document.id,
            vendor: 'AWS India',
            number: 'AWS-2026-11',
            date: month,
            amounts: const InvoiceAmounts(taxable: 100000, cgst: 9000, sgst: 9000, total: 118000),
          ),
        );
      }
    });
  }

  Future<void> mount(
    WidgetTester tester,
    Widget home, {
    Size size = const Size(390, 844),
    bool dark = false,
    double scale = 1,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db), reconciliationServiceProvider.overrideWithValue(service)],
        child: RepaintBoundary(
          key: const ValueKey('capture'),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ledgerTheme(dark ? Brightness.dark : Brightness.light),
            home: home,
          ),
        ),
      ),
    );
    await flush(tester);
  }

  Future<void> close(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    final closed = db.close();
    await flush(tester);
    await tester.runAsync(() => closed);
  }

  ReviewSnapshot snapshot(WidgetTester tester) =>
      ProviderScope.containerOf(tester.element(find.byType(ReconciliationScreen)))
          .read(reconciliationMonthProvider(month))
          .value!;

  testWidgets('one tap business review, merchant memory and custom split work on a phone', (tester) async {
    await seed(tester);
    await mount(tester, ReconciliationScreen(initialMonth: month));
    await capture(tester, 'monthly-phone-start');
    final business = find.byKey(ValueKey('business-$paymentId'));
    await tester.scrollUntilVisible(business, 250, scrollable: find.byType(Scrollable).first);
    await tapVisible(tester, business);
    await flush(tester);
    expect(snapshot(tester).rows.single.transaction.businessUseBps, 10000);
    final remember = find.text('Always use this split');
    await tester.ensureVisible(remember);
    await tapVisible(tester, remember);
    await flush(tester);
    expect(snapshot(tester).rules, hasLength(1));
    final all = find.widgetWithText(ChoiceChip, 'All');
    await tester.ensureVisible(all);
    await tapVisible(tester, all);
    await flush(tester);
    final split = find.byKey(ValueKey('split-$paymentId'));
    await tester.scrollUntilVisible(split, 250, scrollable: find.byType(Scrollable).first);
    await tapVisible(tester, split);
    await flush(tester);
    await tester.enterText(find.byKey(const ValueKey('business-percent')), '50.25');
    tester.testTextInput.hide();
    await tester.pump();
    final save = find.text('Save business share');
    await tester.ensureVisible(save);
    await tapVisible(tester, save);
    await flush(tester);
    expect(snapshot(tester).rows.single.transaction.businessUseBps, 5025);
    expect(snapshot(tester).rows.single.businessShare, 59295);
    expect(tester.takeException(), isNull);
    await close(tester);
  });

  testWidgets('evidence drawer links an exact invoice and can unlink it', (tester) async {
    await seed(tester);
    await tester.runAsync(() => service.classify(paymentId, 5000));
    await mount(
      tester,
      Scaffold(
        body: EvidenceSheet(transactionId: paymentId, month: month),
      ),
    );
    final link = find.byKey(const ValueKey('link-invoice-1'));
    await tester.ensureVisible(link);
    await tapVisible(tester, link);
    await flush(tester);
    expect(find.text('Evidence Matched'), findsOneWidget);
    await capture(tester, 'evidence-phone-matched');
    final unlink = find.byKey(const ValueKey('unlink-1'));
    await tester.ensureVisible(unlink);
    await tapVisible(tester, unlink);
    await flush(tester);
    expect(find.text('Needs Evidence'), findsOneWidget);
    expect(find.byKey(const ValueKey('link-invoice-1')), findsOneWidget);
    expect(tester.takeException(), isNull);
    await close(tester);
  });

  testWidgets('invoice entry rejects incorrect tax totals and saves corrected figures', (tester) async {
    await seed(tester, invoice: false);
    // Use a navigator route so saving closes only the editor.
    await mount(
      tester,
      Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => Scaffold(body: InvoiceEditor(document: document)),
              ),
            ),
            child: const Text('Record invoice'),
          ),
        ),
      ),
    );
    await tapVisible(tester, find.text('Record invoice'));
    await flush(tester);
    for (final entry in {
      'vendor': 'AWS India',
      'number': 'AWS-NEW',
      'date': '2026-11-01',
      'taxable': '1000',
      'total': '1001',
    }.entries) {
      final field = find.byKey(ValueKey('invoice-${entry.key}'));
      await tester.ensureVisible(field);
      await tester.enterText(field, entry.value);
    }
    tester.testTextInput.hide();
    await tester.pump();
    final save = find.byKey(const ValueKey('save-invoice'));
    await tester.ensureVisible(save);
    await tapVisible(tester, save);
    await flush(tester);
    expect(find.textContaining('Invoice total differs'), findsOneWidget);
    final total = find.byKey(const ValueKey('invoice-total'));
    await tester.ensureVisible(total);
    await tester.enterText(total, '1000');
    tester.testTextInput.hide();
    await tester.pump();
    await tester.ensureVisible(save);
    await tapVisible(tester, save);
    await flush(tester);
    expect(find.text('Record invoice'), findsOneWidget);
    expect(find.byKey(const ValueKey('save-invoice')), findsNothing);
    expect(tester.takeException(), isNull);
    await close(tester);
  });

  for (final dark in [false, true]) {
    testWidgets('workspace and evidence adapt to narrow large-text ${dark ? 'dark' : 'light'} layout', (tester) async {
      await seed(tester);
      await tester.runAsync(() => service.classify(paymentId, 5000));
      await mount(
        tester,
        ReconciliationScreen(initialMonth: month),
        size: const Size(320, 760),
        scale: 1.5,
        dark: dark,
      );
      final all = find.widgetWithText(ChoiceChip, 'All');
      await tester.ensureVisible(all);
      await tester.pumpAndSettle();
      await tapVisible(tester, all);
      await flush(tester);
      final evidence = find.byKey(ValueKey('evidence-$paymentId'));
      await tester.scrollUntilVisible(evidence, 200, scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      await capture(tester, 'monthly-large-${dark ? 'dark' : 'light'}');
      await tapVisible(tester, evidence);
      await flush(tester);
      final link = find.byKey(const ValueKey('link-invoice-1'));
      await tester.scrollUntilVisible(
        link,
        200,
        scrollable: find.descendant(of: find.byType(EvidenceSheet), matching: find.byType(Scrollable)).first,
      );
      await tester.pumpAndSettle();
      await capture(tester, 'evidence-large-${dark ? 'dark' : 'light'}');
      expect(tester.takeException(), isNull);
      await close(tester);
    });
  }
}
