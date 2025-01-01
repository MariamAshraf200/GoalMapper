import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di.dart';
import 'core/hiveServices.dart';
import 'feature/taskHome/presintation/bloc/catogeryBloc/CatogeryBloc.dart';
import 'feature/taskHome/presintation/bloc/taskBloc/bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
          create: (context) => sl<TaskBloc>(),
        ),
        BlocProvider<CategoryBloc>(
          create: (context) => sl<CategoryBloc>(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TaskTrack(),
      ),
    );
  }
}
