import 'package:flutter/material.dart';

/// A simple, global theme controller used by the app bootstrapper and UI
/// to read/change the app's theme mode at runtime.
class AppTheme {
  AppTheme._();
  static final AppTheme instance = AppTheme._();

  /// Exposed notifier to allow widgets to listen and rebuild when theme changes.
  final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.dark);

  ThemeMode get current => themeMode.value;

  bool get isDark => themeMode.value == ThemeMode.dark;

  void toggle() {
    themeMode.value = themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  void setMode(ThemeMode mode) {
    themeMode.value = mode;
  }
}

