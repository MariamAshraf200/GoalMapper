import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapper_app/feature/taskHome/presintation/bloc/bloc.dart';
import 'core/constants/app_colors.dart';
import 'core/di.dart';
import 'core/hiveServices.dart';
import 'feature/taskHome/presintation/screen/homeScreen.dart';
import 'feature/taskHome/presintation/screen/taskTrack.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  final hiveService = HiveService();
  await hiveService.initHive();

  await init();

  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:  Brightness.dark ,
        statusBarBrightness:  Brightness.light ,
      ));

}
final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TaskBloc>(),
      child: MaterialApp(
        title: "",
        navigatorKey: navigatorKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.defaultColor),
          //primarySwatch: Colors.grey,
          primaryColor: AppColors.defaultColor,
          appBarTheme: const AppBarTheme(
            elevation: 0, // Removes shadow/elevation
            backgroundColor: Colors.white, // Background for light mode
            iconTheme: IconThemeData(color: Colors.black), // Dark icons
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent, // Transparent status bar
              statusBarIconBrightness: Brightness.dark, // Dark icons for light mode
              statusBarBrightness: Brightness.light, // Light status bar for iOS
            ),
          ),

        ),
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.defaultColor,
            brightness: Brightness.dark,
          ),
          primaryColor: AppColors.defaultColor,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent, // Transparent status bar
              statusBarIconBrightness: Brightness.light, // Dark icons for light mode
              statusBarBrightness: Brightness.dark, // Light status bar for iOS
            ),
          ),
        ),
        themeMode: ThemeMode.light,
        locale: const Locale("en"),
        debugShowCheckedModeBanner: false,
        home: const TaskTrack(),
      ),
    );
  }
}
