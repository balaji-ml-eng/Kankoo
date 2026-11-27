import 'package:flutter/material.dart';

import '../../ui/ledger_theme.dart';

abstract final class AppTheme {
  static ThemeData dark() => ledgerTheme(Brightness.dark);
  static ThemeData light() => ledgerTheme(Brightness.light);
}
