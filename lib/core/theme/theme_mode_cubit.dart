import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeCubit extends Cubit<ThemeMode> {
  static const _prefsKey = 'theme_mode';
  late final SharedPreferences _prefs;

  ThemeModeCubit() : super(ThemeMode.system) {
    _init();
  }

  Future<void> _init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadThemeMode();
    } catch (e) {
      debugPrint('ThemeModeCubit: init failed: $e');
      emit(ThemeMode.system);
    }
  }

  Future<void> _loadThemeMode() async {
    try {
      final value = _prefs.getString(_prefsKey);
      final mode = switch (value) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
      emit(mode);
      debugPrint('ThemeModeCubit: loaded ${mode.name}');
    } catch (e) {
      debugPrint('ThemeModeCubit: failed to load theme mode: $e');
      emit(ThemeMode.system);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      await _prefs.setString(_prefsKey, mode.name);
      emit(mode);
      debugPrint('ThemeModeCubit: set ${mode.name}');
    } catch (e) {
      debugPrint('ThemeModeCubit: failed to save theme mode: $e');
    }
  }

  Future<void> toggle() async {
    final newMode = switch (state) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system => ThemeMode.light, // start with light if system
    };
    await setThemeMode(newMode);
  }
}
