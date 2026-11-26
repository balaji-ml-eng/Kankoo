import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/money_minor.dart';
import '../../data/db/database.dart';
import '../../documents/vault/pdf_vault.dart';
import '../../ingestion/statements/statement_csv.dart';
import '../../ingestion/statements/statement_importer.dart';
import '../../providers.dart';
import '../../ui/ledger_theme.dart';
import 'statement_import_providers.dart';

class StatementImportScreen extends ConsumerStatefulWidget {
  const StatementImportScreen({super.key});
  @override
  ConsumerState<StatementImportScreen> createState() => _StatementImportScreenState();
}

class _StatementImportScreenState extends ConsumerState<StatementImportScreen> {
  final _opening = TextEditingController(), _closing = TextEditingController(), _accountName = TextEditingController();
  CsvStatement? _csv;
  String? _fileName, _error;
  int? _accountId;
  final _columns = <String, int?>{};
  var _header = 0, _revision = 0;
  var _singleAmount = false, _newestFirst = false, _busy = false, _calculating = false;
  bool _addingAccount = false;
  String _dateFormat = statementDateFormats.first;
  StatementPreview? _preview;
  ImportJob? _previous;
  StatementImportResult? _result;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _opening.addListener(_schedulePreview);
    _closing.addListener(_schedulePreview);
    ref.listenManual(accountsProvider, (_, value) {
      final accounts = (value.value ?? <Account>[]).where(_eligible).toList();
      if (mounted && _accountId == null && accounts.length == 1) {
        setState(() => _accountId = accounts.single.id);
        _schedulePreview();
      }
    }, fireImmediately: true);
  }

  bool _eligible(Account a) => !a.archived && a.kind == AccountKind.bank && a.currency == 'INR';
  @override
  void dispose() {
    _debounce?.cancel();
    _opening.dispose();
    _closing.dispose();
    _accountName.dispose();
    super.dispose();
  }

  StatementMapping get _mapping => StatementMapping(
    headerRow: _header,
    date: _columns['date'] ?? -1,
    description: _columns['description'] ?? -1,
    debit: _singleAmount ? null : _columns['debit'],
    credit: _singleAmount ? null : _columns['credit'],
    amount: _singleAmount ? _columns['amount'] : null,
    direction: _singleAmount ? _columns['direction'] : null,
    balance: _columns['balance'],
    reference: _columns['reference'],
    externalId: _columns['externalId'],
    dateFormat: _dateFormat,
    newestFirst: _newestFirst,
  );
  PreviewRequest get _request => PreviewRequest(_csv!, _mapping, _opening.text, _closing.text);

  void _guess(int header) {
    final m = StatementMapping.guess(_csv!.records[header], headerRow: header);
    _header = header;
    _singleAmount = m.singleAmount;
    _columns.addAll({
      'date': m.date < 0 ? null : m.date,
      'description': m.description < 0 ? null : m.description,
      'debit': m.debit,
      'credit': m.credit,
      'amount': m.amount,
      'direction': m.direction,
      'balance': m.balance,
      'reference': m.reference,
      'externalId': m.externalId,
    });
  }

  void _schedulePreview() {
    if (_csv == null || !mounted) return;
    _debounce?.cancel();
    final revision = ++_revision;
    setState(() => _calculating = true);
    _debounce = Timer(const Duration(milliseconds: 180), () async {
      final request = _request, account = _accountId;
      try {
        final preview = await compute(buildStatementPreview, request);
        final previous = account == null
            ? null
            : await ref.read(statementImporterProvider).previousImport(account, preview.fileHash);
        if (mounted && revision == _revision) {
          setState(() {
            _preview = preview;
            _previous = previous;
            _calculating = false;
          });
        }
      } catch (e) {
        if (mounted && revision == _revision) {
          setState(() {
            _error = _message(e);
            _preview = null;
            _calculating = false;
          });
        }
      }
    });
  }

  String _message(Object e) => switch (e) {
    FormatException(:final message) => message,
    StatementImportException(:final message) => message,
    VaultException(:final message) => message,
    _ => 'We couldn’t finish that action. Your existing ledger has been kept. Please try again.',
  };

  Future<void> _chooseCsv() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final file = await ref.read(csvPickerProvider)();
      if (file == null) return;
      final csv = await compute(CsvStatement.decode, file.bytes);
      if (!mounted) return;
      setState(() {
        _csv = csv;
        _fileName = file.name;
        _result = null;
        _preview = null;
        _previous = null;
        _guess(0);
      });
      _schedulePreview();
    } catch (e) {
      if (mounted) setState(() => _error = _message(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _addAccount() async {
    final name = _accountName.text.trim();
    if (name.isEmpty || name.length > 80) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final id = await ref
          .read(databaseProvider)
          .addAccount(name: name, kind: AccountKind.bank, color: 0xff17202b, currency: 'INR');
      if (mounted) {
        setState(() {
          _accountId = id;
          _addingAccount = false;
        });
        _accountName.clear();
        _schedulePreview();
      }
    } catch (e) {
      if (mounted) setState(() => _error = _message(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import() async {
    if (_busy || _calculating || _preview?.balanced != true || _accountId == null || _previous != null) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await ref
          .read(statementImporterProvider)
          .commit(_request, accountId: _accountId!, fileName: _fileName!);
      if (mounted) setState(() => _result = result);
    } catch (e) {
      if (mounted) setState(() => _error = _message(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _attachPdf() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final file = await ref.read(pdfPickerProvider)();
      if (file == null) return;
      final vault = await ref.read(pdfVaultProvider.future);
      await vault.addPdf(file.bytes, originalName: file.name);
    } catch (e) {
      if (mounted) setState(() => _error = _message(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Theme(
    data: ledgerTheme(Theme.of(context).brightness),
    child: Builder(builder: _content),
  );

  Widget _content(BuildContext context) {
    final theme = Theme.of(context), colors = theme.colorScheme;
    final accounts = (ref.watch(accountsProvider).value ?? <Account>[]).where(_eligible).toList();
    final documents = ref.watch(invoiceDocumentsProvider);
    final selected = accounts.any((a) => a.id == _accountId) ? _accountId : null;
    return Scaffold(
      appBar: AppBar(title: Text('Statements & evidence', style: theme.textTheme.titleMedium)),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('YOUR MONTHLY BOOKS', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 1.5)),
                  const SizedBox(height: 10),
                  Text('Every rupee, accounted for.', style: theme.textTheme.headlineLarge),
                  const SizedBox(height: 10),
                  Text(
                    'Bring in your bank statement. Check the balances before a single row enters your ledger.',
                    style: theme.textTheme.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 28),
                  Wrap(
                    spacing: 24,
                    runSpacing: 10,
                    children: [
                      _step(context, '01', 'Source', _csv == null),
                      _step(context, '02', 'Map columns', _csv != null && _preview?.balanced != true),
                      _step(context, '03', 'Reconcile', _preview?.balanced == true),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (_error != null) ...[_notice(context, _error!, LedgerColors.mismatch), const SizedBox(height: 16)],
                  if (_result != null) ...[
                    _panel(
                      context,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle_outline, color: LedgerColors.matched, size: 30),
                          const SizedBox(height: 12),
                          Text('Statement imported', style: theme.textTheme.titleLarge),
                          const SizedBox(height: 8),
                          Text(
                            '${_result!.added} transactions added · ${_result!.matched} existing payments matched · ${_result!.skipped} rows already recorded',
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              FilledButton(
                                onPressed: () => context.push(
                                  '/reconciliation?month=${DateFormat('yyyy-MM').format(_preview!.rows.last.date)}',
                                ),
                                child: const Text('Review monthly books'),
                              ),
                              OutlinedButton(
                                onPressed: _busy ? null : _chooseCsv,
                                child: const Text('Import another statement'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    _panel(
                      context,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.description_outlined, size: 30, color: colors.onSurface),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_fileName ?? 'Start with your bank CSV', style: theme.textTheme.titleMedium),
                                    const SizedBox(height: 4),
                                    Text(
                                      _csv == null
                                          ? 'INR bank statements · CSV up to 10 MB'
                                          : '${_csv!.records.length - 1} records found · stays on this device',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: FilledButton.icon(
                              onPressed: _busy ? null : _chooseCsv,
                              icon: const Icon(Icons.upload_file_outlined, size: 19),
                              label: Text(
                                _busy
                                    ? 'Working…'
                                    : _csv == null
                                    ? 'Choose CSV'
                                    : 'Change statement',
                              ),
                            ),
                          ),
                          if (_csv == null) ...[
                            const SizedBox(height: 16),
                            Text(
                              'Use your bank’s transaction export with a header row. You’ll map the columns and enter the opening and closing balances printed on your statement.',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Bank account', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 10),
                    if (accounts.isNotEmpty)
                      DropdownButtonFormField<int>(
                        key: ValueKey('account-$selected-${accounts.length}'),
                        initialValue: selected,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'Import into'),
                        items: [for (final a in accounts) DropdownMenuItem(value: a.id, child: Text(a.name))],
                        onChanged: _busy
                            ? null
                            : (value) {
                                setState(() => _accountId = value);
                                _schedulePreview();
                              },
                      ),
                    if (accounts.isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: _busy ? null : () => setState(() => _addingAccount = !_addingAccount),
                          icon: Icon(_addingAccount ? Icons.close : Icons.add, size: 18),
                          label: Text(_addingAccount ? 'Cancel new account' : 'Add another bank account'),
                        ),
                      ),
                    if (accounts.isEmpty || _addingAccount) ...[
                      Text('Name the account this statement belongs to.', style: theme.textTheme.bodySmall),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _accountName,
                        maxLength: 80,
                        enabled: !_busy,
                        decoration: const InputDecoration(labelText: 'Bank account name'),
                        onChanged: (_) => setState(() {}),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton(
                          onPressed: _busy || _accountName.text.trim().isEmpty ? null : _addAccount,
                          child: const Text('Add INR bank account'),
                        ),
                      ),
                    ],
                    if (_csv != null) ...[
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Expanded(child: Text('Map your columns', style: theme.textTheme.titleLarge)),
                          TextButton(
                            onPressed: _busy
                                ? null
                                : () {
                                    setState(() => _guess(_header));
                                    _schedulePreview();
                                  },
                            child: const Text('Auto-map'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _fields(context, [
                        DropdownButtonFormField<int>(
                          key: ValueKey('header-$_header-${_csv!.fileHash}'),
                          initialValue: _header,
                          isExpanded: true,
                          decoration: const InputDecoration(labelText: 'Header row'),
                          items: [
                            for (var i = 0; i < math.min(20, _csv!.records.length - 1); i++)
                              DropdownMenuItem(
                                value: i,
                                child: Text(
                                  'Row ${i + 1} · ${_csv!.records[i].join(' / ')}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                          onChanged: _busy
                              ? null
                              : (i) {
                                  if (i != null) {
                                    setState(() => _guess(i));
                                    _schedulePreview();
                                  }
                                },
                        ),
                        DropdownButtonFormField<String>(
                          initialValue: _dateFormat,
                          isExpanded: true,
                          decoration: const InputDecoration(labelText: 'Date format'),
                          items: [for (final f in statementDateFormats) DropdownMenuItem(value: f, child: Text(f))],
                          onChanged: _busy
                              ? null
                              : (v) {
                                  if (v != null) {
                                    setState(() => _dateFormat = v);
                                    _schedulePreview();
                                  }
                                },
                        ),
                        DropdownButtonFormField<bool>(
                          initialValue: _newestFirst,
                          isExpanded: true,
                          decoration: const InputDecoration(labelText: 'Row order'),
                          items: const [
                            DropdownMenuItem(value: false, child: Text('Oldest first')),
                            DropdownMenuItem(value: true, child: Text('Newest first')),
                          ],
                          onChanged: _busy
                              ? null
                              : (v) {
                                  setState(() => _newestFirst = v ?? false);
                                  _schedulePreview();
                                },
                        ),
                      ]),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<bool>(
                        key: ValueKey('layout-$_singleAmount'),
                        initialValue: _singleAmount,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'Amount layout'),
                        items: const [
                          DropdownMenuItem(value: false, child: Text('Separate debit and credit columns')),
                          DropdownMenuItem(value: true, child: Text('Amount and debit/credit marker')),
                        ],
                        onChanged: _busy
                            ? null
                            : (v) {
                                setState(() => _singleAmount = v ?? false);
                                _schedulePreview();
                              },
                      ),
                      const SizedBox(height: 12),
                      _fields(context, [
                        _column(context, 'date', 'Transaction date'),
                        _column(context, 'description', 'Description'),
                        if (_singleAmount) ...[
                          _column(context, 'amount', 'Amount'),
                          _column(context, 'direction', 'Debit / credit marker'),
                        ] else ...[
                          _column(context, 'debit', 'Debit amount'),
                          _column(context, 'credit', 'Credit amount'),
                        ],
                        _column(context, 'balance', 'Running balance', optional: true),
                        _column(context, 'reference', 'UTR / reference', optional: true),
                        _column(context, 'externalId', 'Unique bank transaction ID', optional: true),
                      ]),
                      const SizedBox(height: 14),
                      _panel(
                        context,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Column preview', style: theme.textTheme.labelLarge),
                            const SizedBox(height: 8),
                            for (final field in [
                              ('date', 'Date'),
                              ('description', 'Description'),
                              ('debit', 'Debit'),
                              ('credit', 'Credit'),
                              ('balance', 'Balance'),
                            ])
                              if (_columns[field.$1] != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 3),
                                  child: Text(
                                    '${field.$2}: ${_csv!.records[_header + 1][_columns[field.$1]!.clamp(0, _csv!.records[_header + 1].length - 1)]}',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text('Reconcile the statement', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        'Enter the opening and closing balances from your bank statement. We also check each running balance when a column is mapped.',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 14),
                      _fields(context, [
                        TextField(
                          key: const ValueKey('opening-balance'),
                          controller: _opening,
                          enabled: !_busy,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                          decoration: const InputDecoration(labelText: 'Opening balance', prefixText: '₹ '),
                        ),
                        TextField(
                          key: const ValueKey('closing-balance'),
                          controller: _closing,
                          enabled: !_busy,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                          decoration: const InputDecoration(labelText: 'Closing balance', prefixText: '₹ '),
                        ),
                      ]),
                      const SizedBox(height: 18),
                      if (_calculating)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                              const SizedBox(width: 10),
                              Expanded(child: Text('Checking rows and balances…', style: theme.textTheme.bodySmall)),
                            ],
                          ),
                        ),
                      if (_preview != null) ReconciliationPreviewCard(preview: _preview!),
                      if (_previous != null) ...[
                        const SizedBox(height: 14),
                        _notice(
                          context,
                          'This file has already been imported into this account. Your ledger won’t be duplicated.',
                          null,
                        ),
                      ],
                      if (_preview != null && _preview!.rows.isNotEmpty) ...[
                        const SizedBox(height: 22),
                        Text('Transaction preview', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(
                          'First ${math.min(6, _preview!.rows.length)} of ${_preview!.rows.length} rows · dates and amounts stay as recorded',
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 12),
                        for (final row in _preview!.rows.take(6)) _statementRow(context, row),
                      ],
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed:
                            _busy || _calculating || _preview?.balanced != true || selected == null || _previous != null
                            ? null
                            : _import,
                        child: Text(
                          _busy
                              ? 'Importing statement…'
                              : 'Import ${_preview?.rows.length ?? 0} reconciled transactions',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Nothing is imported until every row and balance check passes. Existing reference matches are linked; possible overlaps stay marked for review.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 26),
                  Text('Keep the invoice with the payment.', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'PDF invoices are encrypted on this device. Attaching a PDF does not mark a payment as evidence matched.',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      onPressed: _busy ? null : _attachPdf,
                      icon: const Icon(Icons.attach_file, size: 18),
                      label: const Text('Attach invoice PDF'),
                    ),
                  ),
                  const SizedBox(height: 14),
                  documents.when(
                    loading: () => Text('Opening your encrypted document list…', style: theme.textTheme.bodySmall),
                    error: (_, _) => _notice(
                      context,
                      'The document list couldn’t be opened. Restart Kankoo to retry; your files have been kept.',
                      LedgerColors.review,
                    ),
                    data: (docs) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final doc in docs.take(5))
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                const Icon(Icons.picture_as_pdf_outlined, size: 20),
                                const SizedBox(width: 12),
                                Expanded(child: Text(doc.originalName, style: theme.textTheme.bodyMedium)),
                                const SizedBox(width: 12),
                                Text('Encrypted', style: theme.textTheme.bodySmall),
                              ],
                            ),
                          ),
                        if (docs.isNotEmpty)
                          Text(
                            '${docs.length} PDFs stored. Keep your originals: full attachment backup is not yet available.',
                            style: theme.textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _column(BuildContext context, String name, String label, {bool optional = false}) {
    final headers = _csv!.records[_header];
    return DropdownButtonFormField<int>(
      key: ValueKey('$name-${_columns[name]}-$_header-${_csv!.fileHash}'),
      initialValue: _columns[name] ?? -1,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: [
        DropdownMenuItem(value: -1, child: Text(optional ? 'Not included' : 'Choose a column')),
        for (var i = 0; i < headers.length; i++)
          DropdownMenuItem(
            value: i,
            child: Text('${i + 1} · ${headers[i]}', overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: _busy
          ? null
          : (v) {
              setState(() => _columns[name] = v == null || v < 0 ? null : v);
              _schedulePreview();
            },
    );
  }

  Widget _fields(BuildContext context, List<Widget> fields) => LayoutBuilder(
    builder: (context, box) {
      final columns = box.maxWidth >= 760
          ? 3
          : box.maxWidth >= 480
          ? 2
          : 1;
      final width = (box.maxWidth - 12 * (columns - 1)) / columns;
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [for (final field in fields) SizedBox(width: width, child: field)],
      );
    },
  );
  Widget _step(BuildContext context, String number, String label, bool active) => Text(
    '$number  $label',
    style: Theme.of(context).textTheme.labelMedium?.copyWith(
      color: active ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurfaceVariant,
    ),
  );
  Widget _statementRow(BuildContext context, StatementRow row) => Container(
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(DateFormat('dd MMM yyyy').format(row.date), style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(row.description, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 6),
        Text(
          formatInrMinor(row.debitMinor > 0 ? -row.amountMinor : row.amountMinor),
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    ),
  );
}

Widget _panel(BuildContext context, Widget child) => Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
  ),
  child: child,
);

Widget _notice(BuildContext context, String text, Color? color) => Container(
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: color ?? Theme.of(context).colorScheme.outlineVariant),
  ),
  child: Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color)),
);

class ReconciliationPreviewCard extends StatelessWidget {
  const ReconciliationPreviewCard({super.key, required this.preview});
  final StatementPreview preview;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context), p = preview;
    final missing = p.openingMinor == null || p.closingMinor == null;
    final color = p.balanced
        ? LedgerColors.matched
        : missing
        ? LedgerColors.review
        : LedgerColors.mismatch;
    return _panel(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(
                p.balanced
                    ? Icons.check_circle_outline
                    : missing
                    ? Icons.info_outline
                    : Icons.error_outline,
                color: color,
                size: 20,
              ),
              Text(
                p.balanced
                    ? 'Balances reconcile'
                    : missing
                    ? 'Enter statement balances'
                    : 'Statement needs attention',
                style: theme.textTheme.titleMedium?.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: 20),
          for (final item in [
            ('Opening balance', p.openingMinor),
            ('Credits', p.creditMinor),
            ('Debits', p.debitMinor),
            ('Calculated closing', p.calculatedClosing),
            ('Statement closing', p.closingMinor),
          ])
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 16,
                runSpacing: 4,
                children: [
                  Text(item.$1, style: theme.textTheme.bodyMedium),
                  Text(item.$2 == null ? 'Not entered' : formatInrMinor(item.$2!), style: theme.textTheme.labelLarge),
                ],
              ),
            ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 16,
            runSpacing: 6,
            children: [
              Text('Difference', style: theme.textTheme.titleMedium),
              Text(
                p.differenceMinor == null ? 'Awaiting balances' : formatInrMinor(p.differenceMinor!),
                style: theme.textTheme.titleLarge?.copyWith(color: color),
              ),
            ],
          ),
          if (p.balanced) ...[
            const SizedBox(height: 12),
            Text(
              p.mapping.balance == null
                  ? 'Statement totals agree. No running-balance column was supplied.'
                  : 'Statement totals and every running balance agree.',
              style: theme.textTheme.bodySmall,
            ),
          ],
          if (p.issues.isNotEmpty) ...[
            const SizedBox(height: 14),
            for (final issue in p.issues.take(5))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(issue, style: theme.textTheme.bodySmall?.copyWith(color: LedgerColors.mismatch)),
              ),
            if (p.issues.length > 5)
              Text('${p.issues.length - 5} more rows need attention.', style: theme.textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}
