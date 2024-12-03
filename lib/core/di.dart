import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../feature/taskHome/data/dataSource/localData.dart';
import '../feature/taskHome/data/model/taskModel.dart';
import '../feature/taskHome/data/repo_impl/repo.dart';
import '../feature/taskHome/domain/repo_interface/repo.dart';
import '../feature/taskHome/domain/usecse/addUsecase.dart';
import '../feature/taskHome/domain/usecse/deleteUsecase.dart';
import '../feature/taskHome/domain/usecse/getUsecase.dart';
import '../feature/taskHome/domain/usecse/updateUsecase.dart';
import '../feature/taskHome/presintation/bloc/bloc.dart';

final sl = GetIt.instance;
Future<void> init() async {
  try {

    final taskBox = Hive.box<TaskModel>('tasks');
    print('Box registered with GetIt: ${taskBox.isOpen}');
    sl.registerSingleton<Box<TaskModel>>(taskBox);

    // Data Sources
    sl.registerLazySingleton<TaskLocalDataSource>(
          () => HiveTaskLocalDataSource(sl()),
    );

    // Repositories
    sl.registerLazySingleton<TaskRepository>(
          () => TaskRepositoryImpl(sl()),
    );

    // Use Cases
    sl.registerLazySingleton(() => AddTaskUseCase(sl()));
    sl.registerLazySingleton(() => GetAllTasksUseCase(sl()));
    sl.registerLazySingleton(() => DeleteTaskUseCase(sl()));
    sl.registerLazySingleton(() => UpdateTaskUseCase(sl()));

    // Bloc
    sl.registerFactory(() => TaskBloc(
      getAllTasksUseCase: sl(),
      addTaskUseCase: sl(),
      updateTaskUseCase: sl(),
      deleteTaskUseCase: sl(),
    ));
  } catch (e) {
    print("Error during DI initialization: $e");
  }
}
