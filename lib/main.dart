import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/di.dart';
import 'core/constants/app_colors.dart';
import 'core/hiveServices.dart';
import 'feature/taskHome/data/model/categoryModel.dart';
import 'feature/taskHome/data/model/taskModel.dart';
import 'feature/taskHome/presintation/bloc/catogeryBloc/CatogeryBloc.dart';
import 'feature/taskHome/presintation/bloc/catogeryBloc/Catogeryevent.dart';
import 'feature/taskHome/presintation/bloc/taskBloc/bloc.dart';
import 'feature/taskHome/presintation/screen/taskTrack.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //final hiveService = HiveService();
 // await hiveService.initHive();
  await Hive.initFlutter();


  // Initialize GetIt
  await init();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

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
        navigatorKey: navigatorKey,
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
        themeMode: ThemeMode.light, // Set default theme mode
        locale: const Locale("en"),

        home: const TaskTrack(), // Replace with your actual home widget
      ),
    );
  }
}
