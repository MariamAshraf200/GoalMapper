import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_imports.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppBootstrapper extends StatelessWidget {
  const AppBootstrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalBloc(
      builder: (context, child) {
        return MultiBlocListener(
          listeners: [
            BlocListener<LanguageCubit, Locale>(
              listener: (context, locale) {},
            ),
            BlocListener<ThemeModeCubit, ThemeMode>(
              listener: (context, mode) {},
            ),
            BlocListener<PaletteCubit, ThemePalette>(
              listener: (context, palette) {},
            ),
            // Top-level listener for auth state changes — navigate to AuthScreen on sign-out
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSignedOut) {
                  // Use the global navigator key so we can navigate from anywhere in the app
                  final nav = navigatorKey.currentState;
                  if (nav != null) {
                    nav.pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                      (route) => false,
                    );
                  }
                }
              },
            ),
          ],
          child: Builder(builder: (context) {
            final themeMode = context.watch<ThemeModeCubit>().state;
            final locale = context.watch<LanguageCubit>().state;
            final palette = context.watch<PaletteCubit>().state;

            return MaterialApp(
              title: AppLocalizations.of(context)?.appTitle ?? 'Task Tracker',
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              navigatorObservers: [routeObserver],
              theme: AppTheme.themeDataFor(palette, Brightness.light),
              darkTheme: AppTheme.themeDataFor(palette, Brightness.dark),
              themeMode: themeMode,
              locale: locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home: const AuthGate(),
            );
          }),
        );
      },
    );
  }
}
