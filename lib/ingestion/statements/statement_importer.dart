import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../data/db/database.dart';
import 'statement_csv.dart';

class StatementImportException implements Exception {
  const StatementImportException(this.message);
  final String message;
  @override
  String toString() => message;
}

class StatementImportResult {
  const StatementImportResult(this.jobId, this.added, this.matched, this.skipped);
  final int jobId, added, matched, skipped;
}

class StatementImporter {
  const StatementImporter(this.db);
  final AppDatabase db;

  Future<ImportJob?> previousImport(int accountId, String hash) =>
      (db.select(db.importJobs)
            ..where((j) => j.sourceAccountId.equals(accountId) & j.fileHash.equals(hash) & j.source.equals('bank_csv')))
          .getSingleOrNull();

  Future<StatementImportResult> commit(
    PreviewRequest request, {
    required int accountId,
    required String fileName,
  }) async {
    // Revalidate at the trust boundary; the UI preview is not an authority.
    final p = await compute(buildStatementPreview, request);
    if (!p.balanced) throw const StatementImportException('Resolve every row and balance difference before importing.');
    return db.transaction(() async {
      final account = await (db.select(db.accounts)..where((a) => a.id.equals(accountId))).getSingleOrNull();
      if (account == null || account.archived || account.kind != AccountKind.bank || account.currency != 'INR') {
        throw const StatementImportException('Choose an active INR bank account.');
      }
      if (await previousImport(accountId, p.fileHash) != null) {
        throw const StatementImportException(
          'This statement is already in your ledger. No transactions were added again.',
        );
      }
      var added = 0, matched = 0, skipped = 0;
      final jobId = await db
          .into(db.importJobs)
          .insert(
            ImportJobsCompanion.insert(
              sourceAccountId: accountId,
              fileHash: p.fileHash,
              fileName: fileName,
              parserVersion: statementParserVersion,
              mappingJson: jsonEncode(p.mapping.toJson()),
              openingMinor: p.openingMinor!,
              closingMinor: p.closingMinor!,
              debitMinor: p.debitMinor,
              creditMinor: p.creditMinor,
              rowCount: p.rows.length,
              skippedCount: Value(p.rows.length),
            ),
          );
      for (final row in p.rows) {
        final known =
            await (db.select(db.sourceEvents)..where(
                  (e) =>
                      e.source.equals('bank_csv') &
                      e.sourceAccountId.equals(accountId) &
                      e.externalId.equals(row.externalId),
                ))
                .getSingleOrNull();
        if (known != null) {
          if (known.contentHash != row.contentHash) {
            throw const StatementImportException(
              'A bank transaction ID has conflicting data. Nothing from this statement was imported.',
            );
          }
          skipped++;
          continue;
        }
        final direction = row.debitMinor > 0 ? TxnDirection.debit : TxnDirection.credit;
        final candidates = (await db.candidatesFor(
          amountMinor: row.amountMinor,
          currency: 'INR',
          direction: direction,
          at: row.date,
          window: const Duration(days: 1),
        )).where((t) => t.accountId == accountId).toList();
        final exact = row.reference == null || row.reference!.length < 6
            ? <Transaction>[]
            : candidates.where((t) => t.reference?.toUpperCase() == row.reference).toList();
        late int txnId;
        if (exact.length == 1) {
          txnId = exact.single.id;
          matched++;
        } else {
          txnId = await db
              .into(db.transactions)
              .insert(
                TransactionsCompanion.insert(
                  amountMinor: row.amountMinor,
                  currency: const Value('INR'),
                  direction: direction,
                  occurredAt: row.date,
                  merchant: Value(row.description),
                  accountId: Value(accountId),
                  reference: Value(row.reference),
                  mode: PaymentMode.other,
                  status: candidates.isEmpty ? TxnStatus.confirmed : TxnStatus.needsReview,
                  duplicateOfId: Value(candidates.length == 1 ? candidates.single.id : null),
                ),
              );
          added++;
          await db.applyBusinessRule(txnId);
        }
        await db
            .into(db.sourceEvents)
            .insert(
              SourceEventsCompanion.insert(
                source: 'bank_csv',
                sourceAccountId: accountId,
                externalId: row.externalId,
                contentHash: row.contentHash,
                receivedAt: row.date,
                importJobId: Value(jobId),
                transactionId: Value(txnId),
                payloadJson: jsonEncode(row.toJson()),
              ),
            );
        await db
            .into(db.rawMessages)
            .insert(
              RawMessagesCompanion.insert(
                source: SourceKind.statement,
                externalId: 'csv:$accountId:${row.externalId}',
                sender: account.name,
                body: jsonEncode(row.toJson()),
                receivedAt: row.date,
                parseStatus: exact.length == 1 ? ParseStatus.merged : ParseStatus.parsed,
                transactionId: Value(txnId),
              ),
            );
      }
      await (db.update(db.importJobs)..where((j) => j.id.equals(jobId))).write(
        ImportJobsCompanion(addedCount: Value(added), matchedCount: Value(matched), skippedCount: Value(skipped)),
      );
      await db
          .into(db.reviewEvents)
          .insert(
            ReviewEventsCompanion.insert(
              entityType: 'import_job',
              entityId: jobId,
              action: 'statement_imported',
              beforeJson: '{}',
              afterJson: jsonEncode({'added': added, 'matched': matched, 'skipped': skipped, 'file_hash': p.fileHash}),
            ),
          );
      return StatementImportResult(jobId, added, matched, skipped);
    });
  }
}
