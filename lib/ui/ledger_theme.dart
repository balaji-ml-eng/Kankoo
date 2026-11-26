import 'package:flutter/material.dart';

abstract final class LedgerColors {
  static const matched = Color(0xFF0D9488);
  static const review = Color(0xFFD97706);
  static const mismatch = Color(0xFFDC2626);
}

ThemeData ledgerTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final background = dark ? const Color(0xFF0F1115) : const Color(0xFFFAFAFA);
  final foreground = dark ? const Color(0xFFF4F5F7) : const Color(0xFF17202B);
  final muted = dark ? const Color(0xFFA2A9B5) : const Color(0xFF606976);
  final line = dark ? const Color(0xFF232730) : const Color(0xFFE5E7EB);
  final surface = dark ? const Color(0xFF15181E) : Colors.white;
  final scheme = ColorScheme.fromSeed(seedColor: foreground, brightness: brightness).copyWith(
    primary: foreground,
    onPrimary: background,
    surface: surface,
    onSurface: foreground,
    onSurfaceVariant: muted,
    outlineVariant: line,
    secondary: foreground,
    onSecondary: background,
    secondaryContainer: line,
    onSecondaryContainer: foreground,
    error: LedgerColors.mismatch,
  );
  final base = ThemeData(brightness: brightness, useMaterial3: true, colorScheme: scheme, fontFamily: 'Roboto');
  TextStyle type(double size, FontWeight weight, {Color? color}) => TextStyle(
    fontFamily: 'Roboto',
    fontSize: size,
    fontWeight: weight,
    color: color ?? foreground,
    height: 1.4,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
  return base.copyWith(
    scaffoldBackgroundColor: background,
    textTheme: base.textTheme.copyWith(
      headlineLarge: type(32, FontWeight.w700),
      headlineMedium: type(26, FontWeight.w700),
      titleLarge: type(20, FontWeight.w600),
      titleMedium: type(16, FontWeight.w600),
      bodyLarge: type(16, FontWeight.w400),
      bodyMedium: type(14, FontWeight.w400),
      bodySmall: type(12, FontWeight.w400, color: muted),
      labelLarge: type(14, FontWeight.w600),
      labelMedium: type(12, FontWeight.w600),
      labelSmall: type(11, FontWeight.w600, color: muted),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: foreground,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    dividerTheme: DividerThemeData(color: line, space: 1, thickness: 1),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: surface,
      selectedColor: line,
      secondarySelectedColor: line,
      labelStyle: type(12, FontWeight.w600),
      secondaryLabelStyle: type(12, FontWeight.w600),
      checkmarkColor: foreground,
      side: BorderSide(color: line),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    sliderTheme: base.sliderTheme.copyWith(
      activeTrackColor: foreground,
      inactiveTrackColor: line,
      thumbColor: foreground,
      overlayColor: foreground.withValues(alpha: 0.08),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: foreground),
      ),
      labelStyle: type(13, FontWeight.w400, color: muted),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: foreground,
        foregroundColor: background,
        minimumSize: const Size(0, 50),
        textStyle: type(14, FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: foreground,
        minimumSize: const Size(0, 48),
        side: BorderSide(color: line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: foreground)),
  );
}
