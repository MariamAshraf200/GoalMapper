import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/theme_mode_cubit.dart';
import 'core/theme/palette_cubit.dart';
import 'feature/auth/presentation/screen/auth_gate.dart';
import 'global_bloc.dart';
import 'l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/i18n/language_cubit.dart';

/// Create a global RouteObserver to monitor route changes.
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); // Global navigator key

class AppBootstrapper extends StatelessWidget {
  const AppBootstrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // ThemeModeCubit, PaletteCubit and LanguageCubit are provided at the top-level (main.dart)
    final themeMode = context.watch<ThemeModeCubit>().state;
    final locale = context.watch<LanguageCubit>().state;
    final palette = context.watch<PaletteCubit>().state;

    return GlobalBloc(
      builder: (context, child) {
        return MaterialApp(
          title: "Task Tracker",
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          navigatorObservers: [routeObserver],
          // Build light/dark themes from the selected palette so theme updates at runtime.
          theme: AppTheme.themeDataFor(palette, Brightness.light),
          darkTheme: AppTheme.themeDataFor(palette, Brightness.dark),
          themeMode: themeMode,
          locale: locale,
          supportedLocales: const [Locale('en'), Locale('ar')],
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          // locale is driven by LanguageCubit (provided at app root)
          home: const AuthGate(),
        );
      },
    );
  }
}
