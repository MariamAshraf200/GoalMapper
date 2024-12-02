
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:mapper_app/feature/taskHome/domain/entity/taskEntity.dart';

import '../feature/taskHome/data/dataSource/localData.dart';
import '../feature/taskHome/data/model/taskModel.dart';
import '../feature/taskHome/data/repo_impl/repo.dart';
import '../feature/taskHome/domain/repo_interface/repo.dart';
import '../feature/taskHome/domain/usecse/addUsecase.dart';
import '../feature/taskHome/domain/usecse/deleteUsecase.dart';
import '../feature/taskHome/domain/usecse/getUsecase.dart';
import '../feature/taskHome/domain/usecse/updateUsecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Initialize Hive
 // await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  var taskBox = await Hive.openBox<Task>('tasks');

  // Data Sources
  sl.registerLazySingleton<TaskLocalDataSource>(
          () => HiveTaskLocalDataSource(taskBox as Box<TaskEntity>));

  // Repositories
  sl.registerLazySingleton<TaskRepository>(
          () => TaskRepositoryImpl(sl()));

  // Use Cases
  sl.registerLazySingleton(() => AddTaskUseCase(sl()));
  sl.registerLazySingleton(() => GetAllTasksUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTaskUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskUseCase(sl()));
}
