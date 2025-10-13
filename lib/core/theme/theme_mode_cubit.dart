import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeCubit extends Cubit<ThemeMode> {
  static const _key = 'theme_mode';

  ThemeModeCubit() : super(ThemeMode.system) {
    loadThemeMode();
  }

  Future<void> loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(_key);
      switch (value) {
        case 'light':
          emit(ThemeMode.light);
          break;
        case 'dark':
          emit(ThemeMode.dark);
          break;
        default:
          emit(ThemeMode.system);
      }
      // debug
      // ignore: avoid_print
      print('ThemeModeCubit: loaded theme mode: ${state.name}');
    } catch (e) {
      // ignore: avoid_print
      print('ThemeModeCubit: failed to load theme mode: $e');
      emit(ThemeMode.system);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ok = await prefs.setString(_key, mode.name);
      // debug
      // ignore: avoid_print
      print('ThemeModeCubit: saved theme mode -> ${mode.name} (ok=$ok)');
    } catch (e) {
      // ignore: avoid_print
      print('ThemeModeCubit: failed to save theme mode: $e');
    }

    // emit after attempting to save so UI matches persisted state
    emit(mode);
    // debug
    // ignore: avoid_print
    print('ThemeModeCubit: emitted theme mode -> ${state.name}');
  }
}
