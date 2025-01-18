import 'package:get_it/get_it.dart';
import '../feature/taskHome/data/dataSource/abstract_data_scource.dart';
import '../feature/taskHome/data/dataSource/catogeryLocalData.dart';
import '../feature/taskHome/data/dataSource/localData.dart';

import '../feature/taskHome/data/repo_impl/repoCatogery.dart';
import '../feature/taskHome/data/repo_impl/repoTask.dart';
import '../feature/taskHome/domain/repo_interface/repoCatogery.dart';
import '../feature/taskHome/domain/repo_interface/repoTask.dart';
import '../feature/taskHome/domain/usecse/catogery/DeleteCategoryUseCase.dart';
import '../feature/taskHome/domain/usecse/catogery/addCatogeriesUseCase.dart';
import '../feature/taskHome/domain/usecse/catogery/getAllCategoriesUseCase.dart';
import '../feature/taskHome/domain/usecse/task/addUsecase.dart';
import '../feature/taskHome/domain/usecse/task/deleteUsecase.dart';
import '../feature/taskHome/domain/usecse/task/filter_tasks.dart';
import '../feature/taskHome/domain/usecse/task/getTaskByDateUsecase.dart';
import '../feature/taskHome/domain/usecse/task/getTaskByPriorityUseCase.dart';
import '../feature/taskHome/domain/usecse/task/getTaskBystatus.dart';
import '../feature/taskHome/domain/usecse/task/getUsecase.dart';
import '../feature/taskHome/domain/usecse/task/updateStatues.dart';
import '../feature/taskHome/domain/usecse/task/updateUsecase.dart';
import '../feature/taskHome/presintation/bloc/catogeryBloc/CatogeryBloc.dart';
import '../feature/taskHome/presintation/bloc/taskBloc/bloc.dart';
import 'hiveServices.dart';

final sl = GetIt.instance;

Future<void> init() async {
  try {
    // Register HiveService
    sl.registerLazySingleton<HiveService>(() => HiveService());

    // Initialize Hive
    final hiveService = sl<HiveService>();
    await hiveService.initHive();

    // Register HiveTaskLocalDataSource
    sl.registerLazySingleton<TaskLocalDataSource>(
          () => HiveTaskLocalDataSource(sl<HiveService>()),
    );

    // Register HiveCategoryLocalDataSource
    sl.registerLazySingleton<HiveCategoryLocalDataSource>(
          () => HiveCategoryLocalDataSource(sl<HiveService>()),
    );

    // Register TaskRepository
    sl.registerLazySingleton<TaskRepository>(
          () => TaskRepositoryImpl(sl<TaskLocalDataSource>()),
    );

    // Register CategoryRepository
    sl.registerLazySingleton<CategoryRepository>(
          () => CategoryRepositoryImpl(sl<HiveCategoryLocalDataSource>()),
    );

    // Register Use Cases for Tasks
    sl.registerLazySingleton(() => AddTaskUseCase(sl<TaskRepository>()));
    sl.registerLazySingleton(() => GetAllTasksUseCase(sl<TaskRepository>()));
    sl.registerLazySingleton(() => DeleteTaskUseCase(sl<TaskRepository>()));
    sl.registerLazySingleton(() => UpdateTaskUseCase(sl<TaskRepository>()));
    sl.registerLazySingleton(() => GetTasksByStatusUseCase(sl<TaskRepository>()));
    sl.registerLazySingleton(() => GetTasksByPriorityUseCase(sl<TaskRepository>()));
    sl.registerLazySingleton(() => UpdateTaskStatusUseCase(sl<TaskRepository>()));
    sl.registerLazySingleton(() => GetTasksByDateUseCase(sl<TaskRepository>()));
    sl.registerLazySingleton(() => FilterTasksUseCase(sl<TaskRepository>()));

    // Register Use Cases for Categories
    sl.registerLazySingleton(() => AddCategoryUseCase(sl<CategoryRepository>()));
    sl.registerLazySingleton(() => GetAllCategoriesUseCase(sl<CategoryRepository>()));
    sl.registerLazySingleton(() => DeleteCategoryUseCase(sl<CategoryRepository>()));

    // Register TaskBloc
    sl.registerFactory(() => TaskBloc(
      getAllTasksUseCase: sl<GetAllTasksUseCase>(),
      addTaskUseCase: sl<AddTaskUseCase>(),
      updateTaskUseCase: sl<UpdateTaskUseCase>(),
      deleteTaskUseCase: sl<DeleteTaskUseCase>(),
      getTasksByStatusUseCase: sl<GetTasksByStatusUseCase>(),
      getTasksByPriorityUseCase: sl<GetTasksByPriorityUseCase>(),
      updateTaskStatusUseCase: sl<UpdateTaskStatusUseCase>(),
      getTasksByDateUseCase: sl<GetTasksByDateUseCase>(),
      filterTasksUseCase: sl<FilterTasksUseCase>(),
    ));

    // Register CategoryBloc
    sl.registerFactory(() => CategoryBloc(
      addCategoryUseCase: sl<AddCategoryUseCase>(),
      getAllCategoriesUseCase: sl<GetAllCategoriesUseCase>(),
      deleteCategoryUseCase: sl<DeleteCategoryUseCase>(),
    ));
  } catch (e, stackTrace) {
    print("Error during DI initialization: $e");
    print(stackTrace);
  }
}

