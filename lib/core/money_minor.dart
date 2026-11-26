const maxLedgerMinor = 9000000000000000;

/// Exact INR input. No binary floating point or silent rounding.
int parseInrMinor(String input, {bool signed = false}) {
  var text = input.trim().replaceFirst(RegExp(r'^(?:₹|INR\s*|Rs\.?\s*)', caseSensitive: false), '').trim();
  var negative = false;
  if (signed && RegExp(r'\s+(?:CR|DR)$', caseSensitive: false).hasMatch(text)) {
    negative = text.toUpperCase().endsWith('DR');
    text = text.replaceFirst(RegExp(r'\s+(?:CR|DR)$', caseSensitive: false), '');
  }
  if (text.startsWith('-') || (text.startsWith('(') && text.endsWith(')'))) {
    if (!signed || negative) throw const FormatException('Use a valid signed balance.');
    negative = true;
    text = text.startsWith('-') ? text.substring(1) : text.substring(1, text.length - 1);
  } else if (text.startsWith('+')) {
    text = text.substring(1);
  }
  if (!RegExp(r'^(?:\d+|\d{1,3}(?:,\d{3})+|\d{1,2}(?:,\d{2})*,\d{3})(?:\.\d{1,2})?$').hasMatch(text)) {
    throw const FormatException('Use a rupee amount with at most two decimal places.');
  }
  final parts = text.replaceAll(',', '').split('.');
  final whole = int.tryParse(parts.first);
  if (whole == null || whole > maxLedgerMinor ~/ 100) {
    throw const FormatException('Amount is outside the supported range.');
  }
  final minor = whole * 100 + (parts.length == 1 ? 0 : int.parse(parts.last.padRight(2, '0')));
  if (minor > maxLedgerMinor) throw const FormatException('Amount is outside the supported range.');
  return negative ? -minor : minor;
}

String formatInrMinor(int minor) {
  final absolute = minor.abs();
  final digits = (absolute ~/ 100).toString();
  var grouped = digits;
  if (digits.length > 3) {
    final head = digits.substring(0, digits.length - 3);
    final pairs = <String>[];
    for (var end = head.length; end > 0; end -= 2) {
      pairs.insert(0, head.substring(end < 2 ? 0 : end - 2, end));
    }
    grouped = '${pairs.join(',')},${digits.substring(digits.length - 3)}';
  }
  return '${minor < 0 ? '−' : ''}₹$grouped.${(absolute % 100).toString().padLeft(2, '0')}';
}
