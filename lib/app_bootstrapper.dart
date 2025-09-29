import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'feature/Home/presentation/screen/homeScreen.dart';
import 'injection_imports.dart';
import 'global_bloc.dart';

/// Create a global RouteObserver to monitor route changes.
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); // Global navigator key

class AppBootstrapper extends StatelessWidget {
  const AppBootstrapper({super.key});

  @override
  Widget build(BuildContext context) {
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
          themeMode: ThemeMode.light,
          locale: const Locale("en"),
          home: const HomeScreen(),
        );
      },
    );
  }
}
