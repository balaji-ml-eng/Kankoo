part of 'database.dart';

String normalizeBusinessMerchant(String text) => text.toLowerCase().replaceAll(RegExp(r'[\s,./_&():;\-]+'), ' ').trim();

extension BusinessReview on AppDatabase {
  Future<void> refreshEvidenceStatus(int transactionId, {int? businessUseBps}) async {
    final txn = await (select(transactions)..where((t) => t.id.equals(transactionId))).getSingle();
    final bps = businessUseBps ?? txn.businessUseBps;
    final links = await (select(paymentAllocations)..where((p) => p.transactionId.equals(transactionId))).get();
    var allocated = 0;
    var consistent = true;
    for (final link in links) {
      allocated += link.allocatedMinor;
      final invoice = await (select(invoices)..where((i) => i.id.equals(link.invoiceId))).getSingle();
      consistent = consistent && invoice.arithmeticStatus == 'consistent';
    }
    final status = bps == 0
        ? 'personal'
        : !consistent || allocated > txn.amountMinor
        ? 'mismatch'
        : allocated == txn.amountMinor && txn.status == TxnStatus.confirmed
        ? 'evidence_matched'
        : 'needs_evidence';
    await (update(transactions)..where((t) => t.id.equals(transactionId))).write(
      TransactionsCompanion(
        reviewStatus: Value(status),
        businessUseBps: businessUseBps == null ? const Value.absent() : Value(businessUseBps),
      ),
    );
  }

  Future<void> classifyBusinessUse(
    int transactionId,
    int bps, {
    String provenance = 'user',
    String? purpose,
    bool remember = false,
  }) => transaction(() async {
    if ((purpose?.length ?? 0) > 300) throw ArgumentError('Keep the business purpose within 300 characters.');
    if (bps < 0 || bps > 10000 || !{'user', 'ca', 'rule'}.contains(provenance)) {
      throw ArgumentError('Choose a business share between 0% and 100%.');
    }
    final txn = await (select(transactions)..where((t) => t.id.equals(transactionId))).getSingle();
    if (txn.currency != 'INR' || txn.isTransfer) {
      throw StateError('Only INR payments outside self-transfers can be reviewed here.');
    }
    if (bps == 0 &&
        (await (select(paymentAllocations)..where((p) => p.transactionId.equals(transactionId))).get()).isNotEmpty) {
      throw StateError('Unlink the evidence before marking this payment personal.');
    }
    final current = await (select(
      classifications,
    )..where((c) => c.transactionId.equals(transactionId))).getSingleOrNull();
    if (current == null) {
      await into(classifications).insert(
        ClassificationsCompanion.insert(
          transactionId: transactionId,
          businessUseBps: bps,
          provenance: provenance,
          businessPurpose: Value(purpose?.trim()),
        ),
      );
    } else {
      await (update(classifications)..where((c) => c.id.equals(current.id))).write(
        ClassificationsCompanion(
          businessUseBps: Value(bps),
          provenance: Value(provenance),
          businessPurpose: purpose == null ? const Value.absent() : Value(purpose.trim()),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
    await refreshEvidenceStatus(transactionId, businessUseBps: bps);
    if (remember) {
      final merchant = normalizeBusinessMerchant(txn.merchant ?? '');
      if (merchant.isEmpty) throw StateError('Add a merchant name before saving a rule.');
      final rule = await (select(businessRules)..where((r) => r.merchantPattern.equals(merchant))).getSingleOrNull();
      if (rule == null) {
        await into(businessRules).insert(
          BusinessRulesCompanion.insert(
            merchantPattern: merchant,
            businessUseBps: bps,
            provenance: Value(provenance == 'ca' ? 'ca' : 'user'),
          ),
        );
      } else {
        await (update(businessRules)..where((r) => r.id.equals(rule.id))).write(
          BusinessRulesCompanion(businessUseBps: Value(bps), provenance: Value(provenance == 'ca' ? 'ca' : 'user')),
        );
      }
    }
  });

  Future<bool> applyBusinessRule(int transactionId) => transaction(() async {
    final txn = await (select(transactions)..where((t) => t.id.equals(transactionId))).getSingle();
    if (txn.currency != 'INR' ||
        txn.isTransfer ||
        txn.direction != TxnDirection.debit ||
        txn.reviewStatus != 'unreviewed' ||
        await (select(classifications)..where((c) => c.transactionId.equals(transactionId))).getSingleOrNull() !=
            null) {
      return false;
    }
    final merchant = normalizeBusinessMerchant(txn.merchant ?? '');
    if (merchant.isEmpty) return false;
    final rule = await (select(businessRules)..where((r) => r.merchantPattern.equals(merchant))).getSingleOrNull();
    if (rule == null) return false;
    await classifyBusinessUse(transactionId, rule.businessUseBps, provenance: 'rule');
    return true;
  });
}
