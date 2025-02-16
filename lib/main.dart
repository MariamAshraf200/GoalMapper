import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapperapp/feature/PlanHome/presentation/bloc/bloc.dart';
import 'core/di.dart';
import 'core/constants/app_colors.dart';
import 'feature/MainScreen/presentation/bloc/main_bloc.dart';
import 'feature/MainScreen/presentation/screen/homeScreen.dart';
import 'feature/taskHome/presintation/bloc/catogeryBloc/CatogeryBloc.dart';
import 'feature/taskHome/presintation/bloc/catogeryBloc/Catogeryevent.dart';
import 'feature/taskHome/presintation/bloc/taskBloc/bloc.dart';

/// Create a global RouteObserver to monitor route changes.
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await init();

  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); // Global navigator key

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainTaskBloc>(
          create: (context) => sl<MainTaskBloc>(),
        ),
        BlocProvider<TaskBloc>(
          create: (context) => sl<TaskBloc>()
        ),
        BlocProvider<CategoryBloc>(
          create: (context) => sl<CategoryBloc>()..add(LoadCategoriesEvent()),
        ),
        BlocProvider<PlanBloc>(
            create: (context)=>sl<PlanBloc>())
      ],
      child: MaterialApp(
        title: "Task Tracker",
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        navigatorObservers: [routeObserver], // Register the global RouteObserver
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
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
          ),
        ),
        themeMode: ThemeMode.dark, // Set default theme mode
        locale: const Locale("en"),
        home: const HomeScreen(), // Your actual home widget
      ),
    );
  }
}
