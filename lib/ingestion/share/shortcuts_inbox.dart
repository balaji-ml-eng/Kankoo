import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class ShortcutsStatus {
  const ShortcutsStatus({required this.enabled, required this.pendingCount, this.lastError});
  final bool enabled;
  final int pendingCount;
  final String? lastError;
}

class ShortcutEnvelope {
  const ShortcutEnvelope(this.id, this.text, this.sender, this.receivedAt);
  final String id, text;
  final String? sender;
  final DateTime receivedAt;
  factory ShortcutEnvelope.fromMap(Map<Object?, Object?> map) {
    final id = map['id'], text = map['text'], sender = map['sender'], time = map['receivedAt'];
    if (id is! String ||
        !RegExp(r'^[0-9a-fA-F]{8}(?:-[0-9a-fA-F]{4}){3}-[0-9a-fA-F]{12}$').hasMatch(id) ||
        text is! String ||
        text.trim().isEmpty ||
        utf8.encode(text).length > 32768 ||
        sender != null && (sender is! String || utf8.encode(sender).length > 512) ||
        time is! int ||
        time < 0 ||
        time >= 4134067200000) {
      throw const FormatException('A forwarded message record is invalid. Its encrypted file was kept.');
    }
    return ShortcutEnvelope(id.toLowerCase(), text, sender as String?, DateTime.fromMillisecondsSinceEpoch(time));
  }
}

class ShortcutBatch {
  const ShortcutBatch(this.items, this.unreadableCount, this.pendingCount);
  final List<ShortcutEnvelope> items;
  final int unreadableCount, pendingCount;
}

/// Native inbox is read without deletion; acknowledge only after the ledger's
/// transaction/raw-message write succeeds. Channels never send text to a server.
class ShortcutsInbox {
  const ShortcutsInbox();
  static const channel = MethodChannel('kankoo/shortcuts');
  bool get isSupported => Platform.isIOS;
  Future<ShortcutsStatus> status() async {
    final map = await channel.invokeMapMethod<Object?, Object?>('status').timeout(const Duration(seconds: 5));
    if (map == null) throw const FormatException('The iPhone forwarding service is unavailable.');
    return ShortcutsStatus(
      enabled: map['enabled'] == true,
      pendingCount: (map['pendingCount'] as int?) ?? 0,
      lastError: map['lastError'] as String?,
    );
  }

  Future<void> setEnabled(bool enabled) =>
      channel.invokeMethod<void>('setEnabled', enabled).timeout(const Duration(seconds: 5));
  Future<ShortcutBatch> pending() async {
    final map = await channel.invokeMapMethod<Object?, Object?>('pending').timeout(const Duration(seconds: 10));
    if (map == null || map['items'] is! List) throw const FormatException('The encrypted inbox could not be opened.');
    final items = (map['items'] as List)
        .map((item) => ShortcutEnvelope.fromMap((item as Map).cast<Object?, Object?>()))
        .toList();
    return ShortcutBatch(items, (map['unreadableCount'] as int?) ?? 0, (map['pendingCount'] as int?) ?? items.length);
  }

  Future<void> acknowledge(String id) =>
      channel.invokeMethod<void>('acknowledge', id).timeout(const Duration(seconds: 5));
  Future<void> enqueueLegacy(String text, String? sender) =>
      channel.invokeMethod<void>('enqueue', {'text': text, 'sender': ?sender}).timeout(const Duration(seconds: 5));
}
