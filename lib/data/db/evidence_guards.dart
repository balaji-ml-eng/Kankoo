part of 'database.dart';

// These protect application writes, not a claim of legal immutability against
// a device owner. Explicit full-ledger restore reinstalls them atomically.
const _allocationChecks = '''
SELECT RAISE(ABORT, 'Allocation exceeds transaction amount') WHERE EXISTS (
  SELECT t.id FROM transactions t JOIN payment_allocations p ON p.transaction_id=t.id
  GROUP BY t.id HAVING SUM(p.allocated_minor)>t.amount_minor
);
SELECT RAISE(ABORT, 'Allocation currency or direction mismatch') WHERE EXISTS (
  SELECT 1 FROM payment_allocations p
  JOIN transactions t ON p.transaction_id=t.id JOIN invoices i ON p.invoice_id=i.id
  WHERE p.currency!=t.currency OR p.currency!=i.currency
    OR (p.kind='payment' AND (t.direction!=0 OR i.kind!='invoice'))
    OR (p.kind='refund' AND t.direction!=1)
);
SELECT RAISE(ABORT, 'Allocation exceeds invoice or available refund balance') WHERE EXISTS (
  SELECT i.id FROM invoices i LEFT JOIN payment_allocations p ON p.invoice_id=i.id
  GROUP BY i.id HAVING
    (i.kind='invoice' AND (COALESCE(SUM(CASE WHEN p.kind='payment' THEN p.allocated_minor ELSE -p.allocated_minor END),0)<0
      OR COALESCE(SUM(CASE WHEN p.kind='payment' THEN p.allocated_minor ELSE -p.allocated_minor END),0)>i.total_minor))
    OR (i.kind='credit_note' AND COALESCE(SUM(p.allocated_minor),0)>i.total_minor)
);
''';

Map<String, String> _evidenceTriggers() => {
  for (final table in ['export_runs', 'export_items'])
    for (final action in ['UPDATE', 'DELETE'])
      '${table}_no_${action.toLowerCase()}':
          "BEFORE $action ON $table BEGIN SELECT RAISE(ABORT, 'Export history is append-only'); END",
  'review_events_no_update':
      "BEFORE UPDATE ON review_events BEGIN SELECT RAISE(ABORT, 'Review history is append-only'); END",
  'review_events_no_delete':
      "BEFORE DELETE ON review_events BEGIN SELECT RAISE(ABORT, 'Review history is append-only'); END",
  for (final action in ['INSERT', 'UPDATE', 'DELETE'])
    'allocation_guard_${action.toLowerCase()}': 'AFTER $action ON payment_allocations BEGIN $_allocationChecks END',
  'transaction_allocation_guard':
      'AFTER UPDATE OF amount_minor, currency, direction ON transactions BEGIN $_allocationChecks END',
  'invoice_allocation_guard': 'AFTER UPDATE OF total_minor, currency, kind ON invoices BEGIN $_allocationChecks END',
  'import_source_guard': '''AFTER UPDATE OF source_account_id, source ON import_jobs BEGIN
    SELECT RAISE(ABORT, 'Import account does not match source evidence') WHERE EXISTS (
      SELECT 1 FROM source_events s WHERE s.import_job_id=NEW.id
        AND (s.source_account_id!=NEW.source_account_id OR s.source!=NEW.source)
    ); END''',
  for (final action in ['INSERT', 'UPDATE'])
    'source_job_guard_${action.toLowerCase()}': '''AFTER $action ON source_events BEGIN
      SELECT RAISE(ABORT, 'Source account does not match import') WHERE NEW.import_job_id IS NOT NULL AND EXISTS (
        SELECT 1 FROM import_jobs j WHERE j.id=NEW.import_job_id AND (j.source_account_id!=NEW.source_account_id OR j.source!=NEW.source)
      ); END''',
  for (final table in ['classifications', 'business_rules', 'payment_allocations'])
    for (final action in ['INSERT', 'UPDATE', 'DELETE'])
      'audit_${table}_${action.toLowerCase()}':
          '''AFTER $action ON $table BEGIN
        INSERT INTO review_events (entity_type,entity_id,action,before_json,after_json,provenance)
        VALUES ('$table',${action == 'DELETE' ? 'OLD' : 'NEW'}.id,'${action.toLowerCase()}',
          ${action == 'INSERT' ? "'{}'" : _auditJson(table, 'OLD')},
          ${action == 'DELETE' ? "'{}'" : _auditJson(table, 'NEW')},${action == 'DELETE' ? 'OLD' : 'NEW'}.provenance); END''',
  'audit_transaction_business_use': '''AFTER UPDATE OF business_use_bps, review_status ON transactions
    WHEN OLD.business_use_bps!=NEW.business_use_bps BEGIN
      INSERT INTO review_events (entity_type,entity_id,action,before_json,after_json,provenance)
      VALUES ('transaction',NEW.id,'business_review',
        json_object('business_use_bps',OLD.business_use_bps,'review_status',OLD.review_status),
        json_object('business_use_bps',NEW.business_use_bps,'review_status',NEW.review_status),
        CASE WHEN OLD.business_use_bps!=NEW.business_use_bps THEN
          COALESCE((SELECT provenance FROM classifications WHERE transaction_id=NEW.id),'user')
          ELSE 'user' END); END''',
};

String _auditJson(String table, String row) => switch (table) {
  'classifications' =>
    "json_object('transaction_id',$row.transaction_id,'business_use_bps',$row.business_use_bps,'business_purpose',$row.business_purpose,'provenance',$row.provenance,'confirmed_category_id',$row.confirmed_category_id,'suggested_category_id',$row.suggested_category_id,'gst_eligibility_status',$row.gst_eligibility_status)",
  'business_rules' =>
    "json_object('merchant_pattern',$row.merchant_pattern,'business_use_bps',$row.business_use_bps,'provenance',$row.provenance)",
  _ =>
    "json_object('transaction_id',$row.transaction_id,'invoice_id',$row.invoice_id,'kind',$row.kind,'allocated_minor',$row.allocated_minor,'currency',$row.currency,'provenance',$row.provenance)",
};

extension EvidenceGuards on AppDatabase {
  Future<void> installEvidenceGuards() async {
    for (final entry in _evidenceTriggers().entries) {
      await customStatement('CREATE TRIGGER IF NOT EXISTS ${entry.key} ${entry.value}');
    }
    await customStatement('CREATE INDEX IF NOT EXISTS idx_sources_transaction ON source_events(transaction_id)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_allocations_invoice ON payment_allocations(invoice_id)');
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_allocations_transaction ON payment_allocations(transaction_id)',
    );
  }

  Future<void> suspendEvidenceGuardsForRestore() async {
    for (final name in _evidenceTriggers().keys) {
      await customStatement('DROP TRIGGER IF EXISTS $name');
    }
  }

  Future<void> validateEvidenceIntegrity() async {
    final badSources = await customSelect('''SELECT 1 FROM source_events s
      JOIN import_jobs j ON j.id=s.import_job_id
      WHERE s.source_account_id!=j.source_account_id OR s.source!=j.source LIMIT 1''').get();
    if (badSources.isNotEmpty) throw StateError('Source account does not match import');
    final foreignKeys = await customSelect('PRAGMA foreign_key_check').get();
    if (foreignKeys.isNotEmpty) throw StateError('The restored ledger contains invalid references');
    // The allocation checks can be reused inside a temporary trigger so they
    // also validate restored snapshots before any transaction is committed.
    await customStatement('CREATE TEMP TABLE IF NOT EXISTS evidence_validation (id INTEGER)');
    await customStatement(
      'CREATE TEMP TRIGGER validate_evidence AFTER INSERT ON evidence_validation BEGIN $_allocationChecks END',
    );
    try {
      await customStatement('INSERT INTO evidence_validation VALUES (1)');
    } finally {
      await customStatement('DROP TRIGGER validate_evidence');
      await customStatement('DELETE FROM evidence_validation');
    }
  }
}
