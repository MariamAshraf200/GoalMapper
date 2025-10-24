import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import 'palettes.dart';

ThemeData _buildFromPalette(PaletteColors p, Brightness brightness) {
  final cs = ColorScheme.fromSeed(
    seedColor: p.primary,
    brightness: brightness,
  ).copyWith(
    secondary: p.secondary,
    tertiary: p.accent,
    onPrimary: AppColors.textOnPrimary,
    surface: p.background,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: cs,
    primaryColor: p.primary,
    scaffoldBackgroundColor: brightness == Brightness.light ? p.background : Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: p.primary,
      foregroundColor: AppColors.textOnPrimary,
      systemOverlayStyle: brightness == Brightness.light
          ? const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      )
          : const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: p.secondary,
      foregroundColor: AppColors.textOnPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: p.primary,
        foregroundColor: AppColors.textOnPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
        ),
      ),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        color: brightness == Brightness.light ? Colors.black87 : Colors.white70,
      ),
      titleLarge: TextStyle(
        fontWeight: FontWeight.bold,
        color: p.primary,
      ),
    ),
    cardColor: p.background,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

class AppTheme {
  AppTheme._();

  static const defaultRadius = 8.0;
  static Color get seedColor => AppColors.primaryColor;

  static ThemeData themeDataFor(ThemePalette palette, Brightness brightness) {
    final p = palette.colors;
    return _buildFromPalette(p, brightness);
  }
}

extension ThemePaletteX on ThemePalette {
  PaletteColors get colors => kPalettes[this] ?? kPalettes[ThemePalette.purple]!;
}
