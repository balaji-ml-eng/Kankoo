import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kankoo/data/db/database.dart';
import 'package:kankoo/ingestion/sms/sms_source.dart';
import 'package:kankoo/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AndroidSmsSource extends SmsSource {
  @override
  bool get isSupported => true;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const sms = MethodChannel('kankoo/sms');
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  tearDown(() => messenger.setMockMethodCallHandler(sms, null));

  test('Activity data includes transactions older than the latest 2000', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await db.batch(
      (b) => b.insertAll(db.transactions, [
        for (var i = 0; i < 2001; i++)
          TransactionsCompanion.insert(
            amountMinor: 100,
            direction: TxnDirection.debit,
            occurredAt: DateTime(2026).add(Duration(minutes: i)),
            merchant: Value('Merchant $i'),
            mode: PaymentMode.cash,
            status: TxnStatus.confirmed,
          ),
      ]),
    );
    final c = ProviderContainer(
      overrides: [prefsProvider.overrideWithValue(prefs), databaseProvider.overrideWithValue(db)],
    );
    addTearDown(c.dispose);
    final sub = c.listen(allTxnsProvider, (_, _) {});
    addTearDown(sub.close);
    final rows = await c.read(allTxnsProvider.future);
    expect(rows, hasLength(2001));
    expect(rows.last.txn.merchant, 'Merchant 0');
  });

  test('SMS pages include all records even when timestamps are equal', () async {
    final at = DateTime(2026).millisecondsSinceEpoch;
    final cursors = <int>[];
    messenger.setMockMethodCallHandler(sms, (call) async {
      final args = call.arguments as Map;
      final after = args['afterId'] as int;
      cursors.add(after);
      final remaining = [1, 2, 3, 4, 5].where((id) => id > after).take(args['limit'] as int);
      return [
        for (final id in remaining) {'id': '$id', 'date': at, 'address': 'VM-HDFCBK', 'body': 'INR 10 debited'},
      ];
    });
    final rows = await AndroidSmsSource().readSince(DateTime(2026), limit: 2);
    expect(rows.map((r) => r.externalId), ['1', '2', '3', '4', '5']);
    expect(cursors, [-1, 2, 4]);
  });

  test('failed SMS page leaves the sync checkpoint unchanged', () async {
    final at = DateTime(2026).millisecondsSinceEpoch;
    SharedPreferences.setMockInitialValues({
      PrefKeys.smsEnabled: true,
      PrefKeys.smsLastSync: at,
      PrefKeys.smsParserVersion: smsParserVersion,
      PrefKeys.skippedReparsed: true,
    });
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    messenger.setMockMethodCallHandler(sms, (call) async {
      if (call.method == 'hasPermission') return true;
      throw PlatformException(code: 'READ_FAILED');
    });
    final c = ProviderContainer(
      overrides: [
        prefsProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(db),
        smsSourceProvider.overrideWithValue(AndroidSmsSource()),
      ],
    );
    addTearDown(c.dispose);
    expect(await c.read(smsSyncProvider.notifier).sync(), isNull);
    expect(prefs.getInt(PrefKeys.smsLastSync), at);
    expect(c.read(smsSyncProvider).running, isFalse);
    expect(c.read(smsSyncProvider).error, isNotNull);
  });
}
