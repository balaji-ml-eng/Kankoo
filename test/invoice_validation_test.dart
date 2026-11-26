import 'package:flutter_test/flutter_test.dart';
import 'package:kankoo/tax_checks/invoice_validation.dart';

void main() {
  test('GSTIN checks structure and checksum without claiming registration', () {
    expect(hasValidGstin('27AAPFU0939F1ZV'), isTrue);
    for (final value in ['27AAPFU0939F1ZA', '00AAPFU0939F1ZV', '27AAPFU0939F1Z', '27AAPFU0939F0ZV']) {
      expect(hasValidGstin(value), isFalse, reason: value);
    }
  });
  test('intrastate taxes, cess and explicit rounding reconcile in paise', () {
    final result = validateInvoiceAmounts(
      const InvoiceAmounts(taxable: 100000, cgst: 9000, sgst: 9000, cess: 1000, rounding: -1, total: 118999),
    );
    expect(result.arithmeticConsistent, isTrue);
    expect(result.label, 'Arithmetic consistent');
  });
  test('multi-rate lines agree with invoice-level tax components', () {
    final result = validateInvoiceAmounts(
      const InvoiceAmounts(taxable: 30000, igst: 4100, total: 34100),
      lines: const [
        InvoiceAmounts(taxable: 10000, igst: 500, total: 10500),
        InvoiceAmounts(taxable: 20000, igst: 3600, total: 23600),
      ],
    );
    expect(result.arithmeticConsistent, isTrue);
  });
  test('negative figures, mixed taxes, line discrepancies and one-paisa errors require review', () {
    for (final amount in [
      const InvoiceAmounts(taxable: 10000, igst: 1800, total: 11801),
      const InvoiceAmounts(taxable: -1, total: -1),
      const InvoiceAmounts(taxable: 10000, igst: 900, cgst: 900, total: 11800),
    ]) {
      expect(validateInvoiceAmounts(amount).arithmeticConsistent, isFalse);
    }
    expect(
      validateInvoiceAmounts(
        const InvoiceAmounts(taxable: 10000, total: 10000),
        lines: const [InvoiceAmounts(taxable: 9000, total: 9000)],
      ).arithmeticConsistent,
      isFalse,
    );
  });
}
