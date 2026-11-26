import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/currency.dart';
import '../../data/db/database.dart';
import '../../data/db/db_encryption.dart';
import '../../providers.dart';
import '../ingestion_service.dart';
import '../parser/parsed_txn.dart';

const notificationChannel = MethodChannel('kankoo/notification-inbox');

/// Validate the entire batch before a single financial row is written.
List<RawInput> notificationInputs(Object? arguments) {
  if (arguments is! Map || arguments['records'] is! List) throw const FormatException('Invalid notification batch');
  final records = arguments['records'] as List;
  if (records.length > 100) throw const FormatException('Notification batch too large');
  final ids = <String>{};
  return [
    for (final record in records)
      () {
        if (record is! Map ||
            record['id'] is! String ||
            !RegExp(r'^[0-9a-f]{64}$').hasMatch(record['id'] as String) ||
            !ids.add(record['id'] as String) ||
            record['package'] is! String ||
            !RegExp(r'^[a-zA-Z0-9_]+(?:\.[a-zA-Z0-9_]+)+$').hasMatch(record['package'] as String) ||
            record['text'] is! String ||
            (record['text'] as String).trim().isEmpty ||
            (record['text'] as String).length > 65536 ||
            record['receivedAt'] is! int ||
            (record['receivedAt'] as int) <= 0 ||
            (record['receivedAt'] as int) > 8640000000000000) {
          throw const FormatException('Invalid notification evidence');
        }
        return RawInput(
          source: SourceKind.notification,
          externalId: 'notification:${record['id']}',
          sender: record['package'] as String,
          body: record['text'] as String,
          receivedAt: DateTime.fromMillisecondsSinceEpoch(record['receivedAt'] as int),
        );
      }(),
  ];
}

/// Return only after commit. Replays after process death retain source IDs and deletion tombstones.
Future<void> consumeNotifications(AppDatabase db, IngestionService service, Object? arguments) async {
  final inputs = notificationInputs(arguments);
  await db.transaction(() async {
    await service.ingest(inputs);
  });
}

Future<void> waitForNotificationWorker() async {
  if (Platform.isAndroid) await notificationChannel.invokeMethod<void>('waitIdle');
}

final notificationConsumerProvider = Provider<void>((ref) {
  if (!Platform.isAndroid) return;
  var busy = false;
  notificationChannel.setMethodCallHandler((call) async {
    if (call.method == 'initialize') {
      await ref.read(databaseProvider).customSelect('SELECT count(*) FROM transactions').get();
      return true;
    }
    if (call.method != 'consume' || busy) return false;
    busy = true;
    try {
      await consumeNotifications(ref.read(databaseProvider), ref.read(ingestionProvider), call.arguments);
      return true;
    } catch (_) {
      return false; // Native queue keeps the encrypted batch and schedules retry.
    } finally {
      busy = false;
    }
  });
  ref.onDispose(() {
    notificationChannel.setMethodCallHandler(null);
  });
  notificationChannel.invokeMethod<void>('foregroundReady').catchError((Object _) {});
});

Future<void> runNotificationWorker() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppDatabase? db;
  var committed = false;
  try {
    final input = await notificationChannel.invokeMethod<Object?>('ready');
    final home = input is Map ? input['homeCurrency'] : null;
    db = AppDatabase(openAppDatabase(existingOnly: true));
    await consumeNotifications(
      db,
      IngestionService(db, homeCurrency: home is String && isSupportedCurrency(home) ? home : 'INR'),
      input,
    );
    committed = true;
  } catch (_) {
    // Do not log message text, database paths, keys or plugin exception details.
  } finally {
    try {
      await db?.close();
    } catch (_) {
      committed = false;
    }
    await notificationChannel.invokeMethod<void>('complete', committed);
  }
}
