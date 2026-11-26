import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kankoo/app.dart';
import 'package:kankoo/data/db/db_encryption.dart';
import 'package:kankoo/ingestion/share/shortcuts_inbox.dart';
import 'package:kankoo/main.dart' as app;
import 'package:kankoo/providers.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('real iPhone bridge imports once into SQLCipher', (tester) async {
    app.main();
    final ready = find.byType(KankooApp);
    final deadline = DateTime.now().add(const Duration(seconds: 40));
    while (ready.evaluate().isEmpty && DateTime.now().isBefore(deadline)) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(ready, findsOneWidget, reason: 'Startup must paint a working app');
    final container = ProviderScope.containerOf(tester.element(ready));
    const inbox = ShortcutsInbox();
    await inbox.setEnabled(true);
    final reference = DateTime.now().millisecondsSinceEpoch.toString().substring(1);
    final message = 'Sent Rs.250.00\nFrom HDFC Bank A/C *4521\nTo TEST MERCHANT\nRef $reference\nNot You?';
    await inbox.enqueueLegacy(message, 'TEST-HDFCBK');
    final batch = await inbox.pending();
    final event = batch.items.singleWhere((event) => event.text == message);
    container.read(onboardedProvider.notifier).complete();
    await tester.pump(const Duration(seconds: 1));
    await container.read(shareIntakeProvider.notifier).retryPending();
    final importDeadline = DateTime.now().add(const Duration(seconds: 30));
    while ((await inbox.status()).pendingCount > 0 && DateTime.now().isBefore(importDeadline)) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect((await inbox.status()).pendingCount, 0);
    final db = container.read(databaseProvider);
    final raw = (await db.select(db.rawMessages).get()).singleWhere((r) => r.externalId == 'ios-${event.id}');
    expect(raw.transactionId, isNotNull);
    final transactions = await db.select(db.transactions).get();
    expect(transactions.singleWhere((t) => t.id == raw.transactionId).amountMinor, 25000);
    expect((await inbox.pending()).items.any((e) => e.id == event.id), false);
    await container.read(shareIntakeProvider.notifier).retryPending();
    expect(await db.select(db.transactions).get(), hasLength(transactions.length));
    expect(DbEncryption.status.value.encrypted, true);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${DbEncryption.fileName}');
    expect(await file.exists(), true);
    final handle = await file.open();
    try {
      expect(await handle.read(16), isNot('SQLite format 3\u0000'.codeUnits));
    } finally {
      await handle.close();
    }
    await inbox.setEnabled(false);
    expect(tester.takeException(), isNull);
  });
}
