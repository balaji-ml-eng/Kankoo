import 'dart:io';

import 'package:flutter/services.dart';

import '../../data/db/tables.dart';
import '../parser/parsed_txn.dart';

/// Reads the device SMS inbox through the native `kankoo/sms` channel
/// (see MainActivity.kt). Android only — iOS gives apps no access to SMS.
class SmsSource {
  static const _channel = MethodChannel('kankoo/sms');
  static const _device = MethodChannel('kankoo/device');

  bool get isSupported => Platform.isAndroid;

  Future<bool> hasPermission() async => isSupported && (await _channel.invokeMethod<bool>('hasPermission') ?? false);

  /// Requests READ_SMS together with RECEIVE_SMS (live alerts). Returns
  /// whether inbox access was granted.
  Future<bool> requestPermission() async =>
      isSupported && (await _channel.invokeMethod<bool>('requestPermission') ?? false);

  /// RECEIVE_SMS, needed for real-time transaction alerts.
  Future<bool> hasReceivePermission() async =>
      isSupported && (await _channel.invokeMethod<bool>('hasReceivePermission') ?? false);

  /// Android 13+ runtime notification permission (no-op when already granted).
  Future<void> requestNotifications() async {
    if (isSupported) await _device.invokeMethod<void>('requestNotifications');
  }

  Future<bool> notificationsAllowed() async =>
      isSupported && (await _device.invokeMethod<bool>('notificationsAllowed') ?? false);

  Future<void> openSettings() async {
    if (isSupported) await _channel.invokeMethod<void>('openSettings');
  }

  /// Reads every page, including messages sharing the same timestamp.
  Future<List<RawInput>> readSince(DateTime since, {int limit = 1000}) async {
    if (!isSupported) return const [];
    if (limit <= 0) throw ArgumentError.value(limit, 'limit');
    final rows = <Map<Object?, Object?>>[];
    var afterMillis = since.millisecondsSinceEpoch;
    var afterId = -1;
    while (true) {
      final page = await _channel.invokeListMethod<Map<Object?, Object?>>('readInbox', {
        'sinceMillis': afterMillis,
        'afterId': afterId,
        'limit': limit,
      });
      if (page == null) throw StateError('SMS inbox could not be read. Please retry.');
      rows.addAll(page);
      if (page.length < limit) break;
      final last = page.last;
      final nextMillis = (last['date']! as num).toInt();
      final nextId = int.parse(last['id']! as String);
      if (nextMillis < afterMillis || (nextMillis == afterMillis && nextId <= afterId)) {
        throw StateError('SMS inbox pagination did not advance. Please retry.');
      }
      afterMillis = nextMillis;
      afterId = nextId;
    }
    return [
      for (final r in rows)
        RawInput(
          source: SourceKind.sms,
          externalId: r['id']! as String,
          sender: r['address']! as String,
          body: r['body']! as String,
          receivedAt: DateTime.fromMillisecondsSinceEpoch((r['date']! as num).toInt()),
        ),
    ];
  }
}
