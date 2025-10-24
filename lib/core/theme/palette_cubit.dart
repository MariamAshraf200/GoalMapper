import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';
import 'palettes.dart';

class PaletteCubit extends Cubit<ThemePalette> {
  static const _kKey = 'theme_palette';
  static const defaultPalette = ThemePalette.purple;

  late final SharedPreferences _prefs;

  PaletteCubit() : super(defaultPalette) {
    _init();
  }

  Future<void> _init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadPalette();
    } catch (e) {
      debugPrint('PaletteCubit: init failed: $e');
    }
  }

  Future<void> _loadPalette() async {
    try {
      final value = _prefs.getString(_kKey);
      if (value != null) {
        final palette = ThemePalette.values.firstWhere(
              (e) => e.name == value,
          orElse: () => defaultPalette,
        );
        emit(palette);
      } else {
        emit(defaultPalette);
      }
      debugPrint('PaletteCubit: loaded ${state.name}');
    } catch (e) {
      debugPrint('PaletteCubit: failed to load palette: $e');
      emit(defaultPalette);
    }
  }

  Future<void> setPalette(ThemePalette palette) async {
    try {
      await _prefs.setString(_kKey, palette.name);
      emit(palette);
      debugPrint('PaletteCubit: set ${palette.name}');
    } catch (e) {
      debugPrint('PaletteCubit: failed to save palette: $e');
    }
  }
}

extension PaletteLocalization on ThemePalette {
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case ThemePalette.purple:
        return l10n.palettePurple;
      case ThemePalette.blue:
        return l10n.paletteBlue;
      case ThemePalette.green:
        return l10n.paletteGreen;
      case ThemePalette.red:
        return l10n.paletteRed;
      case ThemePalette.mix:
        return l10n.paletteMix;
    }
  }
}
