import 'package:kankoo/data/db/database.dart';

/// Rebuild the released v4 transaction shape, including its foreign keys.
/// Other original tables have not changed since v4.
Future<void> makeV4Fixture(AppDatabase db) async {
  await db.customStatement('PRAGMA foreign_keys = OFF');
  await db.transaction(() async {
    await db.suspendEvidenceGuardsForRestore();
    for (final table in db.allTables.toList().reversed) {
      if (!{
        'accounts',
        'categories',
        'transactions',
        'raw_messages',
        'merchant_rules',
        'budgets',
      }.contains(table.actualTableName)) {
        await db.customStatement('DROP TABLE ${table.actualTableName}');
      }
    }
    await db.customStatement('''CREATE TABLE v4_transactions (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    amount_minor INTEGER NOT NULL, currency TEXT NOT NULL DEFAULT 'INR',
    converted_minor INTEGER, converted_currency TEXT, direction INTEGER NOT NULL,
    occurred_at INTEGER NOT NULL, merchant TEXT, counterparty TEXT, note TEXT,
    category_id INTEGER REFERENCES categories(id), account_id INTEGER REFERENCES accounts(id),
    account_hint TEXT, mode INTEGER NOT NULL, reference TEXT, status INTEGER NOT NULL,
    is_transfer INTEGER NOT NULL DEFAULT 0 CHECK(is_transfer IN (0,1)),
    category_locked INTEGER NOT NULL DEFAULT 0 CHECK(category_locked IN (0,1)),
    duplicate_of_id INTEGER, created_at INTEGER NOT NULL DEFAULT (strftime('%s', CURRENT_TIMESTAMP)))''');
    final columns = db.transactions.$columns
        .map((c) => c.name)
        .where((c) => c != 'business_use_bps' && c != 'review_status')
        .join(',');
    await db.customStatement('INSERT INTO v4_transactions ($columns) SELECT $columns FROM transactions');
    await db.customStatement('DROP TABLE transactions');
    await db.customStatement('ALTER TABLE v4_transactions RENAME TO transactions');
    await db.customStatement('CREATE INDEX idx_txn_time ON transactions (occurred_at)');
    await db.customStatement('CREATE INDEX idx_txn_amount ON transactions (amount_minor,direction)');
    await db.customStatement('CREATE INDEX idx_txn_ref ON transactions (reference)');
    await db.customStatement('PRAGMA user_version = 4');
  });
}
