import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/di.dart';
import 'core/constants/app_colors.dart';
import 'feature/MainScreen/presentation/screen/homeScreen.dart';
import 'feature/taskHome/presintation/bloc/catogeryBloc/CatogeryBloc.dart';
import 'feature/taskHome/presintation/bloc/catogeryBloc/Catogeryevent.dart';
import 'feature/taskHome/presintation/bloc/taskBloc/bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize GetIt (Dependency Injection)
  await init();

  // Run the app
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); // Global navigator key

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
          create: (context) => sl<TaskBloc>(),
        ),
        BlocProvider<CategoryBloc>(
          create: (context) => sl<CategoryBloc>()..add(LoadCategoriesEvent()),
        ),
      ],
      child: MaterialApp(
        title: "Task Tracker",
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey, // Pass the global navigatorKey here
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

        home: const HomeScreen(), // Replace with your actual home widget
      ),
    );
  }
}
