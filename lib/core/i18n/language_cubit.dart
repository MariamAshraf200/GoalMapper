import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<Locale> {
  static const _key = 'app_locale';

  LanguageCubit() : super(const Locale('en')) {
    loadLocale();
  }

  Future<void> loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_key);
      if (code == 'ar') {
        emit(const Locale('ar'));
      } else {
        emit(const Locale('en'));
      }
      // ignore: avoid_print
      print('LanguageCubit: loaded locale ${state.languageCode}');
    } catch (e) {
      // ignore: avoid_print
      print('LanguageCubit: loadLocale failed: $e');
      emit(const Locale('en'));
    }
  }

  Future<void> setLocale(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, locale.languageCode);
      emit(locale);
      // ignore: avoid_print
      print('LanguageCubit: set locale ${locale.languageCode}');
    } catch (e) {
      // ignore: avoid_print
      print('LanguageCubit: setLocale failed: $e');
    }
  }

  Future<void> toggle() async {
    final newLocale = state.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
    await setLocale(newLocale);
  }
}

