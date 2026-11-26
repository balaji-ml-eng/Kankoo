import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart' as hashes;
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import '../../core/secrets.dart';
import '../../data/db/database.dart';
import '../../data/db/db_encryption.dart';

class VaultException implements Exception {
  const VaultException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// AES-256-GCM files with independent HKDF-derived keys and fresh random nonces.
/// The master is the existing device-bound DB key; no second key can race its
/// creation or silently replace it. Plaintext PDFs are never written by us.
class PdfVault {
  PdfVault({required this.db, required this.directory, required this.secrets});
  final AppDatabase db;
  final Directory directory;
  final SecretStore secrets;
  static const maxBytes = 25 * 1024 * 1024;
  static final _magic = ascii.encode('KPDF1');
  static final _cipher = AesGcm.with256bits();

  Future<SecretKey> _key(String hash) async {
    final hex = await obtainDbKey(secrets, create: false);
    final bytes = [for (var i = 0; i < hex.length; i += 2) int.parse(hex.substring(i, i + 2), radix: 16)];
    return Hkdf(
      hmac: Hmac.sha256(),
      outputLength: 32,
    ).deriveKey(secretKey: SecretKey(bytes), nonce: utf8.encode('kankoo-invoice-vault-v1'), info: utf8.encode(hash));
  }

  Future<Document> addPdf(List<int> bytes, {required String originalName}) async {
    if (bytes.length < 12 ||
        bytes.length > maxBytes ||
        ascii.decode(bytes.take(5).toList(), allowInvalid: true) != '%PDF-' ||
        !latin1.decode(bytes.sublist(max(0, bytes.length - 1024))).contains('%%EOF')) {
      throw const VaultException('Choose a PDF with a valid header and end marker, up to 25 MB.');
    }
    final hash = await compute(_pdfHash, bytes);
    final name = p.basename(originalName.replaceAll('\\', '/')).replaceAll(RegExp(r'[\x00-\x1f\x7f]'), '').trim();
    if (name.isEmpty || name.length > 180) {
      throw const VaultException('Use a PDF filename between 1 and 180 characters.');
    }
    File? created;
    File? temporary;
    try {
      return await db.transaction(() async {
        final existing = await (db.select(db.documents)..where((d) => d.sha256.equals(hash))).getSingleOrNull();
        if (existing != null) {
          await readPdf(existing);
          return existing;
        }
        await directory.create(recursive: true);
        final file = File(p.join(directory.path, '$hash.kpdf'));
        if (await file.exists()) {
          // Recover a verified encrypted file left by a process killed before DB commit.
          await _decrypt(file, hash);
        } else {
          final packed = await compute(_sealPdf, (
            bytes: bytes,
            key: await (await _key(hash)).extractBytes(),
            hash: hash,
          ));
          final suffix = Random.secure().nextInt(0x7fffffff).toRadixString(16);
          temporary = File('${file.path}.$suffix.tmp');
          await temporary!.writeAsBytes(packed, flush: true);
          await temporary!.rename(file.path);
          temporary = null;
          created = file;
        }
        final id = await db
            .into(db.documents)
            .insert(
              DocumentsCompanion.insert(
                sha256: hash,
                encryptedFilePath: '$hash.kpdf',
                originalName: name,
                byteLength: bytes.length,
              ),
            );
        await db
            .into(db.reviewEvents)
            .insert(
              ReviewEventsCompanion.insert(
                entityType: 'document',
                entityId: id,
                action: 'pdf_attached',
                beforeJson: '{}',
                afterJson: jsonEncode({'sha256': hash, 'name': name, 'bytes': bytes.length}),
              ),
            );
        return (db.select(db.documents)..where((d) => d.id.equals(id))).getSingle();
      });
    } catch (_) {
      // Only remove files owned by this failed write; never another document.
      try {
        if (temporary != null && await temporary!.exists()) await temporary!.delete();
        if (created != null && await created!.exists()) await created!.delete();
      } catch (_) {
        /* Encrypted leftovers can be retried; keep the original error. */
      }
      rethrow;
    }
  }

  Future<Uint8List> readPdf(Document document) async {
    if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(document.sha256) ||
        document.encryptedFilePath != '${document.sha256}.kpdf' ||
        document.encryptionVersion != 1) {
      throw const VaultException('The attachment metadata is invalid. The encrypted file was kept.');
    }
    return _decrypt(File(p.join(directory.path, document.encryptedFilePath)), document.sha256);
  }

  Future<Uint8List> _decrypt(File file, String hash) async {
    if (!await file.exists()) {
      throw const VaultException('The encrypted PDF is missing. Keep your original copy and attach it again.');
    }
    if (await file.length() > maxBytes + 64) throw const VaultException('The encrypted PDF has an invalid size.');
    final bytes = await file.readAsBytes();
    if (bytes.length < 33 || !List.generate(5, (i) => bytes[i] == _magic[i]).every((v) => v)) {
      throw const VaultException('The encrypted PDF has an invalid format.');
    }
    try {
      return await compute(_openPdf, (bytes: bytes, key: await (await _key(hash)).extractBytes(), hash: hash));
    } on SecretBoxAuthenticationError {
      throw const VaultException('The PDF could not be authenticated. Its file and key were preserved.');
    }
  }
}

typedef _VaultCipherInput = ({List<int> bytes, List<int> key, String hash});
String _pdfHash(List<int> bytes) => hashes.sha256.convert(bytes).toString();
Future<Uint8List> _sealPdf(_VaultCipherInput input) async {
  final box = await PdfVault._cipher.encrypt(
    input.bytes,
    secretKey: SecretKey(input.key),
    aad: utf8.encode('kankoo:invoice_pdf:1:${input.hash}'),
  );
  return Uint8List.fromList([...PdfVault._magic, ...box.concatenation()]);
}

Future<Uint8List> _openPdf(_VaultCipherInput input) async {
  final box = SecretBox.fromConcatenation(input.bytes.sublist(5), nonceLength: 12, macLength: 16);
  final clear = await PdfVault._cipher.decrypt(
    box,
    secretKey: SecretKey(input.key),
    aad: utf8.encode('kankoo:invoice_pdf:1:${input.hash}'),
  );
  if (_pdfHash(clear) != input.hash) throw const VaultException('Attachment integrity check failed.');
  return Uint8List.fromList(clear);
}
