import 'package:flutter/material.dart';

/// Brand + semantic colors. Category colors are tuned to stay distinct
/// from each other on both the dark and light surfaces.
abstract final class Palette {
  // Brand
  static const mint = Color(0xFF3DDC97);
  static const violet = Color(0xFF3347A8);
  static const coral = Color(0xFFFF6B6B);
  static const amber = Color(0xFFFFB547);

  // Dark surfaces
  static const ink = Color(0xFF0F1115);
  static const inkRaised = Color(0xFF15181E);
  static const inkHigh = Color(0xFF1D212A);
  static const inkLine = Color(0xFF232730);

  // Light surfaces
  static const paper = Color(0xFFF7F8FC);
  static const paperRaised = Color(0xFFFFFFFF);
  static const paperHigh = Color(0xFFF1F3F5);
  static const paperLine = Color(0xFFE2E7F0);

  static const income = mint;
  static const expense = coral;

  /// Validated categorical set (dataviz validator: lightness band, chroma,
  /// CVD + normal-vision separation, 3:1 contrast — passes on both surfaces).
  /// Order is fixed; colors follow the category, never its rank.
  static const categories = <Color>[
    Color(0xFF3B82F6), // blue
    Color(0xFFE0662C), // orange
    Color(0xFF14A37F), // teal
    Color(0xFFBD8400), // amber
    Color(0xFFD9559B), // pink
    Color(0xFF5E9E1A), // green
    Color(0xFF8577EE), // violet
    Color(0xFF1AA0C4), // cyan
  ];

  /// Catch-all buckets ("Other", transfers, people) — deliberately not a hue.
  static const neutral = Color(0xFF8A90A0);

  /// Gradient used on the hero card.
  static const heroGradient = [Color(0xFF17202B), Color(0xFF1D2939), Color(0xFF253546)];
}
