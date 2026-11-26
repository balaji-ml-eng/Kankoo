import '../core/money_minor.dart';

/// Structural and checksum validation only: never registration/ITC approval.
bool hasValidGstin(String value) {
  final text = value.trim().toUpperCase();
  if (!RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z][1-9A-Z]Z[0-9A-Z]$').hasMatch(text)) return false;
  final state = int.parse(text.substring(0, 2));
  if (!(state >= 1 && state <= 38) && state != 97 && state != 99) return false;
  const alphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  var factor = 2, sum = 0;
  for (var i = 13; i >= 0; i--) {
    final product = alphabet.indexOf(text[i]) * factor;
    sum += product ~/ 36 + product % 36;
    factor = factor == 2 ? 1 : 2;
  }
  return alphabet[(36 - sum % 36) % 36] == text[14];
}

class InvoiceAmounts {
  const InvoiceAmounts({
    required this.taxable,
    required this.total,
    this.cgst = 0,
    this.sgst = 0,
    this.igst = 0,
    this.cess = 0,
    this.rounding = 0,
  });
  final int taxable, total, cgst, sgst, igst, cess, rounding;
  int get calculatedTotal => taxable + cgst + sgst + igst + cess + rounding;
}

class InvoiceValidation {
  const InvoiceValidation(this.issues);
  final List<String> issues;
  bool get arithmeticConsistent => issues.isEmpty;
  String get label => arithmeticConsistent ? 'Arithmetic consistent' : 'Needs review';
}

InvoiceValidation validateInvoiceAmounts(InvoiceAmounts header, {List<InvoiceAmounts> lines = const []}) {
  final issues = <String>[];
  void inspect(InvoiceAmounts a, String label) {
    if ([a.taxable, a.total, a.cgst, a.sgst, a.igst, a.cess].any((n) => n < 0 || n > maxLedgerMinor) ||
        a.rounding.abs() > maxLedgerMinor) {
      issues.add('$label has an invalid monetary value.');
    }
    if (a.igst > 0 && (a.cgst > 0 || a.sgst > 0)) issues.add('$label mixes IGST with CGST/SGST.');
    if (a.calculatedTotal != a.total) {
      issues.add('$label total differs by ${formatInrMinor(a.total - a.calculatedTotal)}.');
    }
  }

  inspect(header, 'Invoice');
  for (var i = 0; i < lines.length; i++) {
    inspect(lines[i], 'Line ${i + 1}');
  }
  if (lines.isNotEmpty) {
    int sum(int Function(InvoiceAmounts) value) => lines.fold(0, (a, b) => a + value(b));
    if (sum((l) => l.taxable) != header.taxable ||
        sum((l) => l.cgst) != header.cgst ||
        sum((l) => l.sgst) != header.sgst ||
        sum((l) => l.igst) != header.igst ||
        sum((l) => l.cess) != header.cess ||
        sum((l) => l.total) + header.rounding != header.total) {
      issues.add('Invoice totals do not agree with the line items.');
    }
  }
  return InvoiceValidation(List.unmodifiable(issues));
}
