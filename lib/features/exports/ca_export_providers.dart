import 'dart:typed_data';

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../exports/ca_bundle.dart';
import '../../providers.dart';
import '../imports/statement_import_providers.dart';

final caExportServiceProvider = Provider(
  (ref) => CaExportService(
    ref.watch(databaseProvider),
    readPdf: (document) async {
      final vault = await ref.read(pdfVaultProvider.future);
      return vault.readPdf(document);
    },
  ),
);
final caExportPreviewProvider = FutureProvider.autoDispose.family<CaPreview, DateTime>(
  (ref, month) => ref.watch(caExportServiceProvider).preview(month),
);
final caExportHistoryProvider = StreamProvider.autoDispose.family<List<ExportRun>, DateTime>((ref, month) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.exportRuns)
        ..where((r) => r.periodStart.equals(DateTime(month.year, month.month)))
        ..orderBy([(r) => OrderingTerm.desc(r.id)]))
      .watch();
});
final caBundleSaverProvider = Provider<Future<bool> Function(String, Uint8List)>(
  (ref) =>
      (name, bytes) async =>
          await FilePicker.saveFile(fileName: name, bytes: bytes, mimeType: 'application/zip') != null,
);
