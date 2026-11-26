import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kankoo/core/security/app_lock.dart';
import 'package:kankoo/data/db/database.dart';
import 'package:kankoo/ingestion/ingestion_service.dart';
import 'package:kankoo/ingestion/share/share_intake.dart';
import 'package:kankoo/ingestion/share/shortcuts_inbox.dart';
import 'package:kankoo/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

const eventId = 'b70135f5-a5e5-4f34-a933-ad22ac754277';
const bankMessage = 'Sent Rs.250.00\nFrom HDFC Bank A/C *4521\nTo SWIGGY\nOn 12/10/26\nRef 528512345678\nNot You?';

class FakeInbox extends ShortcutsInbox {
  final events = <ShortcutEnvelope>[];
  var reads = 0;
  bool failAck = false;
  Future<void> Function()? beforeAck;
  @override
  bool get isSupported => true;
  @override
  Future<ShortcutBatch> pending() async {
    reads++;
    return ShortcutBatch(List.of(events), 0, events.length);
  }

  @override
  Future<void> acknowledge(String id) async {
    await beforeAck?.call();
    if (failAck) throw StateError('simulated acknowledgement failure');
    events.removeWhere((e) => e.id == id);
  }
}

class TestLock extends AppLockController {
  @override
  AppLockState build() => const AppLockState(enabled: true, locked: true);
  void unlockForTest() => state = const AppLockState(enabled: true);
}

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  test('channel rejects malformed records without acknowledging them', () async {
    final calls = <String>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(ShortcutsInbox.channel, (
      call,
    ) async {
      calls.add(call.method);
      return {
        'items': [
          {'id': '../file', 'text': bankMessage, 'receivedAt': 1},
        ],
        'pendingCount': 1,
      };
    });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        ShortcutsInbox.channel,
        null,
      ),
    );
    await expectLater(const ShortcutsInbox().pending(), throwsFormatException);
    expect(calls, ['pending']);
  });

  test('envelope validates time, UTF-8 size and identifiers', () {
    final map = <Object?, Object?>{
      'id': eventId.toUpperCase(),
      'text': bankMessage,
      'sender': 'TESTBANK',
      'receivedAt': 1800000000000,
    };
    expect(ShortcutEnvelope.fromMap(map).id, eventId);
    for (final bad in [
      {...map, 'receivedAt': -1},
      {...map, 'receivedAt': 4134067200000},
      {...map, 'text': ' '},
      {...map, 'text': List.filled(11000, '₹').join()},
      {...map, 'sender': List.filled(513, 'x').join()},
    ]) {
      expect(() => ShortcutEnvelope.fromMap(bad), throwsFormatException);
    }
  });

  test('failed import stays in native inbox; refreshing never queues a record twice', () async {
    final inbox = FakeInbox()..events.add(ShortcutEnvelope(eventId, bankMessage, null, DateTime(2026, 10, 12)));
    final shares = IncomingShares.testing(inbox);
    await shares.refreshNative();
    await shares.refreshNative();
    final event = shares.takeNext();
    expect(shares.hasPending, false);
    shares.retryLater(event);
    expect(inbox.events, hasLength(1));
    await shares.refreshNative();
    expect(shares.takeNext().nativeId, eventId);
    await shares.acknowledge(event);
    expect(inbox.events, isEmpty);
  });

  test('commit before failed ack replays once with original receipt time', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final svc = IngestionService(db);
    final receipt = DateTime(2026, 10, 12, 20);
    final inbox = FakeInbox()..events.add(ShortcutEnvelope(eventId, bankMessage, 'JD-HDFCBK-S', receipt));
    inbox.beforeAck = () async {
      expect(await db.select(db.rawMessages).get(), hasLength(1));
      expect(await db.select(db.transactions).get(), hasLength(1));
    };
    inbox.failAck = true;
    final shares = IncomingShares.testing(inbox);
    await shares.refreshNative();
    final first = shares.takeNext();
    expect((await ingestShared(svc, first)).kind, ShareOutcomeKind.added);
    await expectLater(shares.acknowledge(first), throwsStateError);
    shares.retryLater(first);
    expect(inbox.events, hasLength(1));
    // Simulates process death after ledger commit and before acknowledgement.
    final restarted = IncomingShares.testing(inbox);
    await restarted.refreshNative();
    final replay = restarted.takeNext();
    expect((await ingestShared(svc, replay)).kind, ShareOutcomeKind.duplicate);
    inbox.failAck = false;
    await restarted.acknowledge(replay);
    expect(inbox.events, isEmpty);
    expect(await db.select(db.transactions).get(), hasLength(1));
    final raw = await db.select(db.rawMessages).getSingle();
    expect(raw.externalId, 'ios-$eventId');
    expect(raw.receivedAt, receipt);
  });

  test('controller does not read inbox before onboarding, unlock or foreground', () async {
    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final inbox = FakeInbox()..events.add(ShortcutEnvelope(eventId, bankMessage, null, DateTime(2026, 10, 12)));
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final container = ProviderContainer(
      overrides: [
        prefsProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(db),
        incomingSharesProvider.overrideWithValue(IncomingShares.testing(inbox)),
        appLockProvider.overrideWith(TestLock.new),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(shareIntakeProvider.notifier);
    await controller.retryPending();
    expect(inbox.reads, 0);
    container.read(onboardedProvider.notifier).complete();
    await controller.retryPending();
    expect(inbox.reads, 0);
    binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    (container.read(appLockProvider.notifier) as TestLock).unlockForTest();
    await controller.retryPending();
    expect(inbox.reads, 0);
    // Let queued onboarding/unlock callbacks observe the paused state.
    await Future<void>.delayed(Duration.zero);
    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await controller.retryPending();
    expect(inbox.reads, 1);
    expect(inbox.events, isEmpty);
    expect(await db.select(db.transactions).get(), hasLength(1));
  });

  test('identical alert text on different days is not discarded by a content hash', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final service = IngestionService(db);
    final body = bankMessage
        .split('\n')
        .where((line) => !line.startsWith('On ') && !line.startsWith('Ref '))
        .join('\n');
    for (final (id, day) in [(eventId, 12), ('b70135f5-a5e5-4f34-a933-ad22ac754278', 20)]) {
      final result = await ingestShared(
        service,
        SharedText(text: body, sender: 'JD-HDFCBK-S', nativeId: id, receivedAt: DateTime(2026, 10, day)),
      );
      expect(result.kind, ShareOutcomeKind.added);
    }
    expect(await db.select(db.rawMessages).get(), hasLength(2));
    expect(await db.select(db.transactions).get(), hasLength(2));
  });
}
