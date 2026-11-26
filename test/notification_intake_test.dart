import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:kankoo/data/backup/data_export.dart';
import 'package:kankoo/data/db/database.dart';
import 'package:kankoo/exports/ca_bundle.dart';
import 'package:kankoo/ingestion/ingestion_service.dart';
import 'package:kankoo/ingestion/notifications/notification_intake.dart';
import 'package:kankoo/ingestion/parser/parsed_txn.dart';

Map<String, Object> notificationRecord(int id, {String? text}) => {
  'id': id.toRadixString(16).padLeft(64, '0'),
  'package': 'com.phonepe.app',
  'receivedAt': DateTime(2026, 11, 26, 12).millisecondsSinceEpoch,
  'text': text ?? 'Sent Rs.250.01 From HDFC Bank A/C *4521 To AWS On 26/11/26 Ref 528512345678',
};
Object batch(List<Object> records) => {'records': records};

void main() {
  late AppDatabase db;
  late IngestionService ingestion;
  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    ingestion = IngestionService(db);
  });
  tearDown(() => db.close());
  test('notification batch commits exact paise, provenance and stable IDs before acknowledgement', () async {
    final input = batch([notificationRecord(1)]);
    await consumeNotifications(db, ingestion, input);
    final txn = await db.select(db.transactions).getSingle();
    expect(txn.amountMinor, 25001);
    final raw = await db.select(db.rawMessages).getSingle();
    expect(
      (raw.source, raw.externalId, raw.sender, raw.transactionId),
      (SourceKind.notification, 'notification:${notificationRecord(1)['id']}', 'com.phonepe.app', txn.id),
    );
    await consumeNotifications(db, ingestion, input);
    expect(await db.select(db.transactions).get(), hasLength(1));
    expect(await db.select(db.rawMessages).get(), hasLength(1));
    await db.deleteTxn(txn.id);
    await consumeNotifications(db, ingestion, input);
    expect(await db.select(db.transactions).get(), isEmpty);
    expect((await db.select(db.rawMessages).getSingle()).ignoreReason, 'Deleted by user');
  });
  test('whole batch rollback on database failure permits a clean retry', () async {
    await db.customStatement(
      "CREATE TRIGGER refuse_raw BEFORE INSERT ON raw_messages BEGIN SELECT RAISE(ABORT,'failure'); END",
    );
    final input = batch([notificationRecord(1)]);
    await expectLater(consumeNotifications(db, ingestion, input), throwsA(anything));
    expect(await db.select(db.transactions).get(), isEmpty);
    expect(await db.select(db.rawMessages).get(), isEmpty);
    expect(await db.select(db.accounts).get(), isEmpty);
    await db.customStatement('DROP TRIGGER refuse_raw');
    await consumeNotifications(db, ingestion, input);
    expect(await db.select(db.transactions).get(), hasLength(1));
  });
  test('invalid later record refuses entire batch without storing the first', () async {
    final invalid = {...notificationRecord(2), 'text': ''};
    await expectLater(
      consumeNotifications(db, ingestion, batch([notificationRecord(1), invalid])),
      throwsFormatException,
    );
    expect(await db.select(db.rawMessages).get(), isEmpty);
    expect(await db.select(db.transactions).get(), isEmpty);
    for (final bad in [
      null,
      {'records': 'bad'},
      batch([notificationRecord(1), notificationRecord(1)]),
      batch([
        {...notificationRecord(2), 'id': 'bad'},
      ]),
      batch([
        {...notificationRecord(2), 'package': '../bad'},
      ]),
      batch([
        {...notificationRecord(2), 'receivedAt': -1},
      ]),
      batch([
        {...notificationRecord(2), 'text': 'x' * 65537},
      ]),
      batch(List.generate(101, notificationRecord)),
    ]) {
      expect(() => notificationInputs(bad), throwsFormatException);
    }
  });
  test('OTP, offers and unfamiliar formats retain their recorded outcomes', () async {
    await consumeNotifications(
      db,
      ingestion,
      batch([
        notificationRecord(1, text: 'Your OTP is 123456 for Rs.250 payment. Do not share.'),
        notificationRecord(2, text: 'Offer! Win Rs.500 cashback, apply now'),
        notificationRecord(3, text: 'Debit card transaction Rs.250 processed by your bank'),
      ]),
    );
    final rows = await db.select(db.rawMessages).get();
    expect(rows, hasLength(3));
    expect(rows.where((r) => r.parseStatus == ParseStatus.ignored), hasLength(2));
    expect(rows.where((r) => r.parseStatus == ParseStatus.pendingLlm), hasLength(1));
    expect(await db.select(db.transactions).get(), isEmpty);
  });
  test('SMS and notification evidence with same bank reference merge without duplicating payment', () async {
    final record = notificationRecord(1);
    await ingestion.ingest([
      RawInput(
        source: SourceKind.sms,
        externalId: 'sms-1',
        sender: 'VM-HDFCBK',
        body: record['text'] as String,
        receivedAt: DateTime(2026, 11, 26, 12),
      ),
    ]);
    await consumeNotifications(db, ingestion, batch([record]));
    expect(await db.select(db.transactions).get(), hasLength(1));
    expect(await db.select(db.rawMessages).get(), hasLength(2));
    expect((await db.select(db.rawMessages).get()).last.parseStatus, ParseStatus.merged);
  });
  test('old source indices stay unchanged and backups retain notification provenance', () async {
    expect(SourceKind.values.map((s) => s.name), ['sms', 'email', 'manual', 'shortcut', 'statement', 'notification']);
    await consumeNotifications(db, ingestion, batch([notificationRecord(1)]));
    final backup = await DataExport(db).backupJson();
    final restored = AppDatabase(NativeDatabase.memory());
    try {
      await DataExport(restored).restore(backup);
      expect((await restored.select(restored.rawMessages).getSingle()).source, SourceKind.notification);
      await consumeNotifications(restored, IngestionService(restored), batch([notificationRecord(1)]));
      expect(await restored.select(restored.transactions).get(), hasLength(1));
    } finally {
      await restored.close();
    }
  });
  test(
    'CA bundle includes notification receipt hashes and unreadable outcomes without raw notification text',
    () async {
      await consumeNotifications(
        db,
        ingestion,
        batch([
          notificationRecord(1),
          notificationRecord(2, text: 'Debit card transaction Rs.250 processed by your bank'),
        ]),
      );
      final result = await CaExportService(
        db,
        readPdf: (_) async => throw StateError('No PDFs'),
      ).create(DateTime(2026, 11));
      final archive = ZipDecoder().decodeBytes(result.bytes);
      final receipts = utf8.decode(archive.findFile('notification_sources.csv')!.content);
      expect(receipts, contains('com.phonepe.app'));
      expect(receipts, contains('pendingLlm'));
      expect(receipts, isNot(contains('Sent Rs.250.01')));
      expect(receipts.split('\r\n'), hasLength(4));
    },
  );
}
