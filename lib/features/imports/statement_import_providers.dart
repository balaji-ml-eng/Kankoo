import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../data/db/database.dart';
import '../../documents/vault/pdf_vault.dart';
import '../../ingestion/statements/statement_importer.dart';
import '../../providers.dart';

class ImportFile {
  const ImportFile(this.name, this.bytes);
  final String name;
  final List<int> bytes;
}

Future<ImportFile?> _pick(String extension, int maxBytes) async {
  final file = await FilePicker.pickFile(
    type: FileType.custom,
    allowedExtensions: [extension],
    dialogTitle: extension == 'csv' ? 'Choose bank statement' : 'Choose invoice PDF',
  );
  if (file == null) return null;
  final size = await file.length();
  if (size != null && (size <= 0 || size > maxBytes)) {
    throw FormatException('Choose a non-empty $extension smaller than ${maxBytes ~/ 1024 ~/ 1024} MB.');
  }
  final bytes = <int>[];
  await for (final chunk in file.readAsByteStream()) {
    if (bytes.length + chunk.length > maxBytes) throw const FormatException('This file is too large.');
    bytes.addAll(chunk);
  }
  return ImportFile(file.name, bytes);
}

final csvPickerProvider = Provider<Future<ImportFile?> Function()>(
  (ref) =>
      () => _pick('csv', 10 * 1024 * 1024),
);
final pdfPickerProvider = Provider<Future<ImportFile?> Function()>(
  (ref) =>
      () => _pick('pdf', PdfVault.maxBytes),
);
final statementImporterProvider = Provider((ref) => StatementImporter(ref.watch(databaseProvider)));
final pdfVaultProvider = FutureProvider((ref) async {
  final directory = await getApplicationDocumentsDirectory();
  return PdfVault(
    db: ref.watch(databaseProvider),
    secrets: ref.watch(secretStoreProvider),
    directory: Directory(p.join(directory.path, 'invoice_vault')),
  );
});
final invoiceDocumentsProvider = StreamProvider<List<Document>>(
  (ref) =>
      (ref.watch(databaseProvider).select(ref.watch(databaseProvider).documents)
            ..orderBy([(d) => OrderingTerm.desc(d.createdAt)]))
          .watch(),
);
