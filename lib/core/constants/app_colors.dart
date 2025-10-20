import 'package:flutter/material.dart';

class AppColors {
  // Primary brand color (purple)
  static const Color primaryColor = Color(0xFF6A1B9A); // deep purple
  // defaultColor kept as alias for backward compatibility
  static const Color defaultColor = primaryColor;

  // Secondary / accent
  static const Color secondaryColor = Color(0xFF00BFA5); // teal
  static const Color accentColor = Color(0xFFFFC107); // amber
  static const Color dangerColor = Color(0xFFB00020);

  // Backgrounds
  static final Color defaultBackgroundColor = Color(0xFFF7F6FB); // very light purple tint
  static final Color secondBackgroundColor = Colors.white;

  // Surface / basic
  static const Color basicColor = Colors.white;

  // Text colors
  static const Color textPrimary = Colors.black87;
  static const Color textOnPrimary = Colors.white;
}
