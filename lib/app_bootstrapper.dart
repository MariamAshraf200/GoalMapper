import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapperapp/feature/auth/presentation/screen/auth_gate.dart';
import 'core/theme/theme_mode_cubit.dart';
import 'core/i18n/language_cubit.dart';
import 'injection_imports.dart';
import 'global_bloc.dart';
import 'l10n/app_localizations.dart';

/// Create a global RouteObserver to monitor route changes.
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); // Global navigator key

class AppBootstrapper extends StatelessWidget {
  const AppBootstrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // ThemeModeCubit and LanguageCubit are provided at the top-level (main.dart)
    final themeMode = context.watch<ThemeModeCubit>().state;
    final locale = context.watch<LanguageCubit>().state;

    return GlobalBloc(
      builder: (context, child) {
        return MaterialApp(
          title: "Task Tracker",
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          navigatorObservers: [routeObserver],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.defaultColor),
            primaryColor: AppColors.defaultColor,
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.defaultColor,
              brightness: Brightness.dark,
            ),
            primaryColor: AppColors.defaultColor,
            appBarTheme: AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark,
              ),
            ),
          ),
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
