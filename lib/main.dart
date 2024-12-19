import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapper_app/feature/taskHome/presintation/bloc/bloc.dart';
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
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TaskBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TaskTrack(),
      ),
    );
  }
}
