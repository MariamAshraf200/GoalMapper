import 'package:flutter/widgets.dart';

import 'app_localizations.dart';
import 'app_localizations_en.dart';

/// Convenience extension to access generated localizations from a BuildContext.
///
/// Usage: `context.l10n.someKey`
///
/// This returns a non-null `AppLocalizations` instance. If the
/// localization delegate hasn't been loaded into the context yet,
/// it falls back to English (`AppLocalizationsEn`) to avoid
/// runtime null-check exceptions.
extension L10nBuildContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this) ?? AppLocalizationsEn();
}
