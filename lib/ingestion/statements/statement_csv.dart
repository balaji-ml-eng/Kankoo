import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../../core/money_minor.dart';

const statementParserVersion = 1;
const statementDateFormats = ['dd/MM/yyyy', 'dd-MM-yyyy', 'yyyy-MM-dd', 'dd-MMM-yyyy', 'MM/dd/yyyy'];

class CsvStatement {
  const CsvStatement(this.fileHash, this.records);
  final String fileHash;
  final List<List<String>> records;

  static CsvStatement decode(List<int> bytes) {
    if (bytes.isEmpty || bytes.length > 10 * 1024 * 1024) {
      throw const FormatException('Choose a non-empty CSV smaller than 10 MB.');
    }
    var text = utf8.decode(bytes);
    if (text.startsWith('\ufeff')) text = text.substring(1);
    final delimiter = _delimiter(text);
    final records = <List<String>>[];
    var row = <String>[];
    final cell = StringBuffer();
    var quoted = false, closedQuote = false;
    void field() {
      row.add(cell.toString());
      cell.clear();
      closedQuote = false;
    }

    void record() {
      field();
      if (row.any((v) => v.trim().isNotEmpty)) records.add(row);
      row = [];
      if (records.length > 50001) throw const FormatException('Import at most 50,000 transactions at a time.');
    }

    for (var i = 0; i < text.length; i++) {
      final c = text[i];
      if (quoted) {
        if (c == '"') {
          if (i + 1 < text.length && text[i + 1] == '"') {
            cell.write('"');
            i++;
          } else {
            quoted = false;
            closedQuote = true;
          }
        } else {
          cell.write(c);
        }
      } else if (c == delimiter) {
        field();
      } else if (c == '\r' || c == '\n') {
        if (c == '\r' && i + 1 < text.length && text[i + 1] == '\n') i++;
        record();
      } else if (c == '"') {
        if (cell.isNotEmpty || closedQuote) throw const FormatException('A CSV field has an unexpected quote.');
        quoted = true;
      } else if (closedQuote) {
        if (c.trim().isNotEmpty) throw const FormatException('Unexpected text after a quoted CSV field.');
      } else {
        cell.write(c);
      }
    }
    if (quoted) throw const FormatException('A quoted CSV field is not closed.');
    if (cell.isNotEmpty || row.isNotEmpty || closedQuote) record();
    if (records.length < 2) throw const FormatException('The CSV needs a header and at least one transaction.');
    return CsvStatement(sha256.convert(bytes).toString(), records);
  }

  static String _delimiter(String text) {
    final counts = {',': 0, ';': 0, '\t': 0};
    var quoted = false;
    for (var i = 0; i < text.length; i++) {
      if (text[i] == '"') {
        if (quoted && i + 1 < text.length && text[i + 1] == '"') {
          i++;
          continue;
        }
        quoted = !quoted;
      }
      if (!quoted && counts.containsKey(text[i])) counts[text[i]] = counts[text[i]]! + 1;
      if (!quoted && text[i] == '\n' && counts.values.any((n) => n > 0)) break;
    }
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }
}

class StatementMapping {
  const StatementMapping({
    required this.date,
    required this.description,
    this.debit,
    this.credit,
    this.amount,
    this.direction,
    this.balance,
    this.reference,
    this.externalId,
    this.headerRow = 0,
    this.dateFormat = 'dd/MM/yyyy',
    this.newestFirst = false,
  });
  final int date, description, headerRow;
  final int? debit, credit, amount, direction, balance, reference, externalId;
  final String dateFormat;
  final bool newestFirst;
  bool get singleAmount => amount != null;

  factory StatementMapping.guess(List<String> headers, {int headerRow = 0}) {
    final names = headers.map((s) => s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '')).toList();
    int? find(List<String> aliases) {
      final index = names.indexWhere(aliases.contains);
      return index < 0 ? null : index;
    }

    final debit = find(['debit', 'debitamount', 'withdrawal', 'withdrawalamount', 'withdrawals', 'dr']);
    final credit = find(['credit', 'creditamount', 'deposit', 'depositamount', 'deposits', 'cr']);
    return StatementMapping(
      headerRow: headerRow,
      date: find(['date', 'transactiondate', 'txndate', 'valuedate', 'postingdate']) ?? -1,
      description:
          find(['description', 'narration', 'particulars', 'transactiondescription', 'details', 'remarks']) ?? -1,
      debit: debit,
      credit: credit,
      amount: debit == null && credit == null ? find(['amount', 'transactionamount']) : null,
      direction: debit == null && credit == null
          ? find(['type', 'direction', 'drcr', 'crdr', 'transactiontype'])
          : null,
      balance: find(['balance', 'closingbalance', 'runningbalance', 'availablebalance']),
      reference: find(['reference', 'ref', 'utr', 'rrn', 'referenceno', 'referencenumber', 'chequerefno']),
      externalId: find(['transactionid', 'txnid', 'entryid', 'banktransactionid']),
    );
  }

  Map<String, Object?> toJson() => {
    'headerRow': headerRow,
    'date': date,
    'description': description,
    'debit': debit,
    'credit': credit,
    'amount': amount,
    'direction': direction,
    'balance': balance,
    'reference': reference,
    'externalId': externalId,
    'dateFormat': dateFormat,
    'newestFirst': newestFirst,
  };
}

class StatementRow {
  const StatementRow({
    required this.record,
    required this.date,
    required this.description,
    required this.debitMinor,
    required this.creditMinor,
    required this.externalId,
    required this.contentHash,
    this.balanceMinor,
    this.reference,
  });
  final int record;
  final DateTime date;
  final String description, externalId, contentHash;
  final int debitMinor, creditMinor;
  final int? balanceMinor;
  final String? reference;
  int get amountMinor => debitMinor + creditMinor;
  Map<String, Object?> toJson() => {
    'record': record,
    'date': date.toIso8601String(),
    'description': description,
    'debit_minor': debitMinor,
    'credit_minor': creditMinor,
    'balance_minor': balanceMinor,
    'reference': reference,
  };
}

class StatementPreview {
  const StatementPreview({
    required this.fileHash,
    required this.mapping,
    required this.rows,
    required this.issues,
    required this.debitMinor,
    required this.creditMinor,
    required this.openingMinor,
    required this.closingMinor,
  });
  final String fileHash;
  final StatementMapping mapping;
  final List<StatementRow> rows;
  final List<String> issues;
  final int debitMinor, creditMinor;
  final int? openingMinor, closingMinor;
  int? get calculatedClosing => openingMinor == null ? null : openingMinor! + creditMinor - debitMinor;
  int? get differenceMinor =>
      calculatedClosing == null || closingMinor == null ? null : calculatedClosing! - closingMinor!;
  bool get balanced => issues.isEmpty && rows.isNotEmpty && differenceMinor == 0;
}

class PreviewRequest {
  const PreviewRequest(this.statement, this.mapping, this.opening, this.closing);
  final CsvStatement statement;
  final StatementMapping mapping;
  final String opening, closing;
}

/// Pure and isolate-safe. Every malformed row blocks the entire import.
StatementPreview buildStatementPreview(PreviewRequest request) {
  final csv = request.statement, m = request.mapping;
  final issues = <String>[];
  final rows = <StatementRow>[];
  var debits = 0, credits = 0;
  int? opening, closing;
  try {
    if (request.opening.trim().isNotEmpty) opening = parseInrMinor(request.opening, signed: true);
  } on FormatException catch (e) {
    issues.add('Opening balance: ${e.message}');
  }
  try {
    if (request.closing.trim().isNotEmpty) closing = parseInrMinor(request.closing, signed: true);
  } on FormatException catch (e) {
    issues.add('Closing balance: ${e.message}');
  }
  final indexes = [
    m.date,
    m.description,
    if (m.singleAmount) ...[?m.amount, ?m.direction] else ...[?m.debit, ?m.credit],
    ?m.balance,
    ?m.reference,
    ?m.externalId,
  ];
  final validHeader = m.headerRow >= 0 && m.headerRow < csv.records.length - 1;
  if (!validHeader ||
      indexes.any((i) => i < 0 || i >= csv.records[m.headerRow].length) ||
      indexes.toSet().length != indexes.length ||
      (m.singleAmount ? m.direction == null : m.debit == null || m.credit == null) ||
      !statementDateFormats.contains(m.dateFormat)) {
    issues.add('Map distinct date, description and debit/credit columns before reviewing.');
  } else {
    final source = [for (var i = m.headerRow + 1; i < csv.records.length; i++) (i + 1, csv.records[i])];
    if (m.newestFirst) source.reverseRange(0, source.length);
    final occurrence = <String, int>{};
    final ids = <String>{};
    DateTime? previousDate;
    var expectedBalance = opening;
    for (final (number, fields) in source) {
      try {
        if (fields.length != csv.records[m.headerRow].length) {
          throw const FormatException('Column count differs from the header.');
        }
        String cell(int? index) => index == null ? '' : fields[index].trim();
        final date = parseStatementDate(cell(m.date), m.dateFormat);
        if (date.year < 1970 || date.year > 2100) throw const FormatException('Date is outside the supported range.');
        if (previousDate != null && date.isBefore(previousDate)) {
          throw const FormatException('Dates are out of order. Check the date format and statement order.');
        }
        final description = cell(m.description);
        if (description.isEmpty) throw const FormatException('Transaction description is missing.');
        int value(int? index) => cell(index).isEmpty ? 0 : parseInrMinor(cell(index));
        var debit = 0, credit = 0;
        if (m.singleAmount) {
          final amount = value(m.amount);
          final direction = cell(m.direction).toLowerCase();
          if (['dr', 'debit', 'd', 'withdrawal'].contains(direction)) {
            debit = amount;
          } else if (['cr', 'credit', 'c', 'deposit'].contains(direction)) {
            credit = amount;
          } else {
            throw const FormatException('Use a recognised debit/credit marker.');
          }
        } else {
          debit = value(m.debit);
          credit = value(m.credit);
        }
        if ((debit > 0) == (credit > 0)) throw const FormatException('Exactly one debit or credit must be positive.');
        final balance = m.balance == null ? null : parseInrMinor(cell(m.balance), signed: true);
        final reference = cell(m.reference).isEmpty ? null : cell(m.reference).toUpperCase();
        final canonical = jsonEncode([
          date.toIso8601String(),
          description.replaceAll(RegExp(r'\s+'), ' ').toLowerCase(),
          debit,
          credit,
          balance,
          reference,
        ]);
        final hash = sha256.convert(utf8.encode(canonical)).toString();
        final count = occurrence.update(hash, (n) => n + 1, ifAbsent: () => 1);
        final id = m.externalId == null ? '$hash:$count' : 'bank:${cell(m.externalId)}';
        if (m.externalId != null && cell(m.externalId).isEmpty) {
          throw const FormatException('Bank transaction ID is missing.');
        }
        if (!ids.add(id)) throw const FormatException('Bank transaction ID occurs more than once.');
        if (debits + debit > maxLedgerMinor || credits + credit > maxLedgerMinor) {
          throw const FormatException('Statement total is outside the supported range.');
        }
        rows.add(
          StatementRow(
            record: number,
            date: date,
            description: description,
            debitMinor: debit,
            creditMinor: credit,
            balanceMinor: balance,
            reference: reference,
            externalId: id,
            contentHash: hash,
          ),
        );
        debits += debit;
        credits += credit;
        previousDate = date;
        if (expectedBalance != null) {
          expectedBalance += credit - debit;
          if (balance != null && expectedBalance != balance) {
            issues.add('Row $number: running balance differs by ${formatInrMinor(balance - expectedBalance)}.');
          }
        }
      } on FormatException catch (e) {
        issues.add('Row $number: ${e.message}');
      }
    }
  }
  return StatementPreview(
    fileHash: csv.fileHash,
    mapping: m,
    rows: List.unmodifiable(rows),
    issues: List.unmodifiable(issues),
    debitMinor: debits,
    creditMinor: credits,
    openingMinor: opening,
    closingMinor: closing,
  );
}

extension<T> on List<T> {
  void reverseRange(int start, int end) {
    final reversed = sublist(start, end).reversed.toList();
    setRange(start, end, reversed);
  }
}

/// Explicit formats keep ambiguous bank dates independent of device locale
/// and avoid locale initialization in background isolates.
DateTime parseStatementDate(String text, String format) {
  final numeric = RegExp(r'^(\d{1,2})([/\-])(\d{1,2})\2(\d{4})$').firstMatch(text);
  int? day, month, year;
  if (format == 'yyyy-MM-dd') {
    final match = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$').firstMatch(text);
    if (match != null) {
      year = int.parse(match[1]!);
      month = int.parse(match[2]!);
      day = int.parse(match[3]!);
    }
  } else if (format == 'dd-MMM-yyyy') {
    final match = RegExp(r'^(\d{1,2})-([A-Za-z]{3})-(\d{4})$').firstMatch(text);
    if (match != null) {
      day = int.parse(match[1]!);
      year = int.parse(match[3]!);
      month =
          const [
            'jan',
            'feb',
            'mar',
            'apr',
            'may',
            'jun',
            'jul',
            'aug',
            'sep',
            'oct',
            'nov',
            'dec',
          ].indexOf(match[2]!.toLowerCase()) +
          1;
    }
  } else if (numeric != null && numeric[2] == (format == 'dd-MM-yyyy' ? '-' : '/')) {
    year = int.parse(numeric[4]!);
    day = int.parse(numeric[format == 'MM/dd/yyyy' ? 3 : 1]!);
    month = int.parse(numeric[format == 'MM/dd/yyyy' ? 1 : 3]!);
  }
  if (day == null || month == null || year == null || year < 1970 || year > 2100) {
    throw FormatException('Date must match $format.');
  }
  final date = DateTime(year, month, day);
  if (date.year != year || date.month != month || date.day != day) {
    throw const FormatException('Date is not a real calendar day.');
  }
  return date;
}
