import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kankoo/core/secrets.dart';
import 'package:kankoo/data/backup/data_export.dart';
import 'package:kankoo/data/db/database.dart';
import 'package:kankoo/data/db/db_encryption.dart';
import 'package:kankoo/documents/vault/pdf_vault.dart';

class VaultSecrets extends SecretStore {
  String? key = 'a' * 64;
  @override
  Future<String?> read(String name) async => name == DbEncryption.secretKey ? key : null;
  @override
  Future<void> write(String name, String? value) async => throw StateError('Vault must never replace the DB key');
}

final invoicePdf = utf8.encode('%PDF-1.4\n1 0 obj\n<< /Type /Catalog >>\nendobj\ntrailer\n<< /Root 1 0 R >>\n%%EOF\n');

void main() {
  late AppDatabase db;
  late Directory dir;
  late VaultSecrets secrets;
  late PdfVault vault;
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    dir = Directory.systemTemp.createTempSync('kankoo_vault_');
    secrets = VaultSecrets();
    vault = PdfVault(db: db, directory: dir, secrets: secrets);
  });
  tearDown(() async {
    await db.close();
    dir.deleteSync(recursive: true);
  });
  test('PDF round trip uses ciphertext only and deduplicates the document', () async {
    final document = await vault.addPdf(invoicePdf, originalName: 'invoice.pdf');
    final disk = File('${dir.path}/${document.encryptedFilePath}').readAsBytesSync();
    expect(latin1.decode(disk).contains('%PDF-'), isFalse);
    expect(await vault.readPdf(document), invoicePdf);
    expect((await vault.addPdf(invoicePdf, originalName: 'renamed.pdf')).id, document.id);
    expect(await db.select(db.documents).get(), hasLength(1));
    expect(dir.listSync(), hasLength(1));
    expect((await db.select(db.reviewEvents).get()).single.action, 'pdf_attached');
  });
  test('modified ciphertext fails authentication and preserves the file', () async {
    final document = await vault.addPdf(invoicePdf, originalName: 'invoice.pdf');
    final file = File('${dir.path}/${document.encryptedFilePath}');
    final bytes = file.readAsBytesSync();
    bytes[20] ^= 1;
    file.writeAsBytesSync(bytes);
    await expectLater(vault.readPdf(document), throwsA(isA<VaultException>()));
    expect(file.existsSync(), isTrue);
  });
  test('wrong and missing keys cannot open or silently replace encrypted files', () async {
    final document = await vault.addPdf(invoicePdf, originalName: 'invoice.pdf');
    secrets.key = 'b' * 64;
    await expectLater(vault.readPdf(document), throwsA(isA<VaultException>()));
    secrets.key = null;
    await expectLater(vault.readPdf(document), throwsStateError);
    secrets.key = 'a' * 64;
    expect(await vault.readPdf(document), invoicePdf);
  });
  test('invalid files leave neither document rows nor orphaned files', () async {
    await expectLater(
      vault.addPdf(utf8.encode('<html>Not a PDF</html>'), originalName: 'fake.pdf'),
      throwsA(isA<VaultException>()),
    );
    expect(await db.select(db.documents).get(), isEmpty);
    expect(dir.listSync(), isEmpty);
  });
  test('database-only backups cannot pretend to preserve PDF attachments', () async {
    await vault.addPdf(invoicePdf, originalName: 'invoice.pdf');
    await expectLater(DataExport(db).backupJson(), throwsA(isA<BackupFormatException>()));
  });
}
