import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapper_app/feature/taskHome/domain/usecse/task/getTaskByDateUsecase.dart';
import 'package:mapper_app/feature/taskHome/domain/usecse/task/getTaskBystatus.dart';
import 'package:mapper_app/feature/taskHome/domain/usecse/task/updateStatues.dart';
import '../feature/taskHome/data/dataSource/catogeryLocalData.dart';
import '../feature/taskHome/data/dataSource/localData.dart';
import '../feature/taskHome/data/model/categoryModel.dart';
import '../feature/taskHome/data/model/taskModel.dart';
import '../feature/taskHome/data/repo_impl/repoCatogery.dart';
import '../feature/taskHome/data/repo_impl/repoTask.dart';
import '../feature/taskHome/domain/repo_interface/repoCatogery.dart';
import '../feature/taskHome/domain/repo_interface/repoTask.dart';
import '../feature/taskHome/domain/usecse/catogery/DeleteCategoryUseCase.dart';
import '../feature/taskHome/domain/usecse/catogery/GetAllCategoriesUseCase].dart';
import '../feature/taskHome/domain/usecse/catogery/addCatogeriesUseCase.dart';
import '../feature/taskHome/domain/usecse/task/addUsecase.dart';
import '../feature/taskHome/domain/usecse/task/deleteUsecase.dart';
import '../feature/taskHome/domain/usecse/task/getUsecase.dart';
import '../feature/taskHome/domain/usecse/task/updateUsecase.dart';
import '../feature/taskHome/presintation/bloc/catogeryBloc/CatogeryBloc.dart';
import '../feature/taskHome/presintation/bloc/taskBloc/bloc.dart';

final sl = GetIt.instance;
Future<void> init() async {
  try {
    final taskBox = Hive.box<TaskModel>('tasks');
    print('Box registered with GetIt: ${taskBox.isOpen}');
    sl.registerSingleton<Box<TaskModel>>(taskBox);

    final categoryBox = await Hive.openBox<CategoryModel>('categories');
    print('Category box registered: ${categoryBox.isOpen}');
    sl.registerSingleton<Box<CategoryModel>>(categoryBox);

    // Data Sources
    sl.registerLazySingleton<TaskLocalDataSource>(
      () => HiveTaskLocalDataSource(sl()),
    );
    sl.registerLazySingleton<HiveCategoryLocalDataSource>(
          () => HiveCategoryLocalDataSource(sl<Box<CategoryModel>>()),
    );


    // Repositories
    sl.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImpl(sl()),
    );

    sl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(sl()),
    );

    // Use Cases
    sl.registerLazySingleton(() => AddTaskUseCase(sl()));
    sl.registerLazySingleton(() => GetAllTasksUseCase(sl()));
    sl.registerLazySingleton(() => DeleteTaskUseCase(sl()));
    sl.registerLazySingleton(() => UpdateTaskUseCase(sl()));
    sl.registerLazySingleton(() => GetTasksByStatusUseCase(sl()));
    sl.registerLazySingleton(() => UpdateTaskStatusUseCase(sl()));
    sl.registerLazySingleton(() => GetTasksByDateUseCase(sl()));
    sl.registerLazySingleton(() => AddCategoryUseCase(sl()));
    sl.registerLazySingleton(() => GetAllCategoriesUseCase(sl()));
    sl.registerLazySingleton(() => DeleteCategoryUseCase(sl()));

    // Register Bloc
    sl.registerFactory(() => TaskBloc(
        getAllTasksUseCase: sl(),
        addTaskUseCase: sl(),
        updateTaskUseCase: sl(),
        deleteTaskUseCase: sl(),
        getTasksByStatusUseCase: sl(),
        updateTaskStatusUseCase: sl(),
        getTasksByDateUseCase: sl()));
    sl.registerFactory(() => CategoryBloc(
          addCategoryUseCase: sl(),
          getAllCategoriesUseCase: sl(),
          deleteCategoryUseCase: sl(),
        ));
  } catch (e) {
    print("Error during DI initialization: $e");
  }
}
