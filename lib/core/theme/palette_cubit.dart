// filepath: c:\Users\USER\StudioProjects\mapperapp\lib\core\theme\palette_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';
import 'palettes.dart';

class PaletteCubit extends Cubit<ThemePalette> {
  static const _kKey = 'theme_palette';

  PaletteCubit() : super(ThemePalette.purple) {
    _loadPalette();
  }

  Future<void> _loadPalette() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(_kKey);
      if (value != null) {
        final palette = ThemePalette.values.firstWhere(
          (e) => e.name == value,
          orElse: () => ThemePalette.purple,
        );
        emit(palette);
      }
    } catch (e) {
      // ignore errors - keep default
      // ignore: avoid_print
      print('PaletteCubit: failed to load palette: $e');
    }
  }

  Future<void> setPalette(ThemePalette palette) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kKey, palette.name);
    } catch (e) {
      // ignore: avoid_print
      print('PaletteCubit: failed to save palette: $e');
    }
    emit(palette);
  }

  Map<String, String> getColorNames(AppLocalizations l10n) {
    return {
      'purple': l10n.palettePurple,
      'blue': l10n.paletteBlue,
      'green': l10n.paletteGreen,
      'red': l10n.paletteRed,
      'mix': l10n.paletteMix,
    };
  }
}
