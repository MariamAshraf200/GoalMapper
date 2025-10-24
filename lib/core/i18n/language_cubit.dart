import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<Locale> {
  static const _key = 'app_locale';
  late final SharedPreferences _prefs;

  LanguageCubit() : super(const Locale('en')) {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    await loadLocale();
  }

  Future<void> loadLocale() async {
    try {
      final code = _prefs.getString(_key);
      if (code != null) {
        emit(Locale(code));
      } else {
        emit(const Locale('en'));
      }
      debugPrint('LanguageCubit: loaded ${state.languageCode}');
    } catch (e) {
      debugPrint('LanguageCubit: loadLocale failed: $e');
      emit(const Locale('en'));
    }
  }

  Future<void> setLocale(Locale locale) async {
    try {
      await _prefs.setString(_key, locale.languageCode);
      emit(locale);
      debugPrint('LanguageCubit: set ${locale.languageCode}');
    } catch (e) {
      debugPrint('LanguageCubit: setLocale failed: $e');
    }
  }

  Future<void> toggle() async {
    final newLocale = state.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
    await setLocale(newLocale);
  }
}
