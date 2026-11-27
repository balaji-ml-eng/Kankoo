import 'package:flutter/material.dart';

abstract final class LedgerColors {
  static const brand = Color(0xFF3347A8);
  static const midnight = Color(0xFF1B2855);
  static const matched = Color(0xFF0D9488);
  static const review = Color(0xFFD97706);
  static const mismatch = Color(0xFFDC2626);
}

ThemeData ledgerTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final background = dark ? const Color(0xFF0F1115) : const Color(0xFFF7F8FC);
  final foreground = dark ? const Color(0xFFF4F5F7) : const Color(0xFF17202B);
  final muted = dark ? const Color(0xFFA2A9B5) : const Color(0xFF606976);
  final line = dark ? const Color(0xFF232730) : const Color(0xFFE2E7F0);
  final surface = dark ? const Color(0xFF15181E) : Colors.white;
  final brand = dark ? const Color(0xFFB2C0FF) : LedgerColors.brand;
  final brandTint = dark ? const Color(0xFF273153) : const Color(0xFFEBEFFE);
  final onBrand = dark ? const Color(0xFF142044) : Colors.white;
  final scheme = ColorScheme.fromSeed(seedColor: foreground, brightness: brightness).copyWith(
    primary: brand,
    onPrimary: onBrand,
    surface: surface,
    surfaceContainerLowest: background,
    surfaceContainerLow: surface,
    surfaceContainer: surface,
    surfaceContainerHigh: line,
    surfaceContainerHighest: line,
    surfaceTint: Colors.transparent,
    onSurface: foreground,
    onSurfaceVariant: muted,
    outlineVariant: line,
    secondary: brand,
    onSecondary: onBrand,
    secondaryContainer: brandTint,
    onSecondaryContainer: brand,
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
      headlineSmall: type(22, FontWeight.w600),
      displaySmall: type(38, FontWeight.w600).copyWith(height: 1.12, letterSpacing: -1.3),
      displayMedium: type(44, FontWeight.w600).copyWith(height: 1.08, letterSpacing: -1.6),
      titleLarge: type(20, FontWeight.w600),
      titleMedium: type(16, FontWeight.w600),
      titleSmall: type(14, FontWeight.w600),
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
      titleTextStyle: type(18, FontWeight.w600).copyWith(letterSpacing: -0.4),
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: line),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: background,
      surfaceTintColor: Colors.transparent,
      indicatorColor: brandTint,
      height: 72,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => type(
          11,
          states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
          color: states.contains(WidgetState.selected) ? brand : muted,
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(style: IconButton.styleFrom(foregroundColor: brand)),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: line,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: brand,
      foregroundColor: onBrand,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: foreground,
      contentTextStyle: type(14, FontWeight.w400, color: background),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: brand, linearTrackColor: line),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: BorderSide(color: muted, width: 1.4),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: muted,
      titleTextStyle: type(15, FontWeight.w500),
      subtitleTextStyle: type(12, FontWeight.w400, color: muted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      textColor: foreground,
      collapsedTextColor: foreground,
      iconColor: muted,
      collapsedIconColor: muted,
      shape: const Border(),
      collapsedShape: const Border(),
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 16),
    ),
    dividerTheme: DividerThemeData(color: line, space: 1, thickness: 1),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: surface,
      selectedColor: brandTint,
      secondarySelectedColor: brandTint,
      labelStyle: type(12, FontWeight.w600),
      showCheckmark: false,
      secondaryLabelStyle: type(12, FontWeight.w600, color: brand),
      checkmarkColor: brand,
      side: BorderSide(color: line),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    sliderTheme: base.sliderTheme.copyWith(
      activeTrackColor: brand,
      inactiveTrackColor: line,
      thumbColor: brand,
      overlayColor: brand.withValues(alpha: 0.08),
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
        borderSide: BorderSide(color: brand),
      ),
      labelStyle: type(13, FontWeight.w400, color: muted),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: brand,
        foregroundColor: onBrand,
        minimumSize: const Size(0, 52),
        textStyle: type(14, FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: brand,
        minimumSize: const Size(0, 48),
        side: BorderSide(color: line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: brand)),
  );
}
