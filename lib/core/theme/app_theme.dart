import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import 'palettes.dart';

// Helper to build ThemeData from a PaletteColors instance
ThemeData _buildFromPalette(PaletteColors p, Brightness brightness) {
  final cs = ColorScheme.fromSeed(seedColor: p.primary, brightness: brightness).copyWith(
    secondary: p.secondary,
    tertiary: p.accent,
    onPrimary: AppColors.textOnPrimary,
    surface: AppColors.basicColor,
  );

  return ThemeData(
    brightness: brightness,
    colorScheme: cs,
    primaryColor: p.primary,
    scaffoldBackgroundColor: (brightness == Brightness.light) ? p.background : Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: p.primary,
      foregroundColor: AppColors.textOnPrimary,
      systemOverlayStyle: brightness == Brightness.light
          ? const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark, statusBarBrightness: Brightness.light)
          : const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light, statusBarBrightness: Brightness.dark),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: p.secondary,
      foregroundColor: AppColors.textOnPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: p.primary,
        foregroundColor: AppColors.textOnPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    cardColor: AppColors.basicColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

class AppTheme {
  AppTheme._();

  // Expose a seed color for consistent Material 3 color generation
  static Color get seedColor => AppColors.primaryColor;

  // Build theme dynamically from a chosen palette
  static ThemeData themeDataFor(ThemePalette palette, Brightness brightness) {
    final p = kPalettes[palette] ?? kPalettes[ThemePalette.purple]!;
    return _buildFromPalette(p, brightness);
  }
}
