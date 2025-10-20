import 'package:flutter/material.dart';

enum ThemePalette { purple, blue, green, red ,mix}

class PaletteColors {
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;

  const PaletteColors({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
  });
}

const Map<ThemePalette, PaletteColors> kPalettes = {
  ThemePalette.purple: PaletteColors(
    primary: Color(0xFF7E57C2),   // Lavender purple
    secondary: Color(0xFF9575CD), // Soft lilac
    accent: Color(0xFFF8BBD0),    // Pink highlight
    background: Color(0xFFF3E5F5), // Light lavender background
  ),

  ThemePalette.blue: PaletteColors(
    primary: Color(0xFF42A5F5),   // Sky blue
    secondary: Color(0xFF64B5F6), // Light blue
    accent: Color(0xFF90CAF9),    // Subtle aqua
    background: Color(0xFFE3F2FD), // Cloudy light blue
  ),

  ThemePalette.green: PaletteColors(
    primary: Color(0xFF43A047),   // Calm green
    secondary: Color(0xFF66BB6A), // Fresh mint
    accent: Color(0xFFA5D6A7),    // Soft pastel green
    background: Color(0xFFE8F5E9), // Light mint background
  ),

  ThemePalette.red: PaletteColors(
    primary: Color(0xFFE53935),   // Coral red
    secondary: Color(0xFFEF5350), // Soft red
    accent: Color(0xFFFFCDD2),    // Light rose
    background: Color(0xFFFFEBEE), // Pale pink background
  ),
  ThemePalette.mix: PaletteColors(
    primary: Color(0xFF00BFA5), // deep purple
    secondary: Color(0xFF6A1B9A), // teal
    accent: Color(0xFFFFC107), // amber
    background: Color(0xFFF7F6FB),
  ),
};
