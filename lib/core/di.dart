import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
import '../feature/taskHome/domain/usecse/task/filter_tasks.dart';
import '../feature/taskHome/domain/usecse/task/getTaskByDateUsecase.dart';
import '../feature/taskHome/domain/usecse/task/getTaskBystatus.dart';
import '../feature/taskHome/domain/usecse/task/getUsecase.dart';
import '../feature/taskHome/domain/usecse/task/updateStatues.dart';
import '../feature/taskHome/domain/usecse/task/updateUsecase.dart';
import '../feature/taskHome/presintation/bloc/catogeryBloc/CatogeryBloc.dart';
import '../feature/taskHome/presintation/bloc/taskBloc/bloc.dart';
import 'hiveServices.dart';

final sl = GetIt.instance;

// Future<void> init() async {
//   try {
//     // Initialize Hive boxes
//     final taskBox = Hive.box<TaskModel>('tasks');
//     sl.registerSingleton<Box<TaskModel>>(taskBox);
//
//     final categoryBox = await Hive.openBox<CategoryModel>('categories');
//     sl.registerSingleton<Box<CategoryModel>>(categoryBox);
//
//     // Data Sources
//     sl.registerLazySingleton<TaskLocalDataSource>(() => HiveTaskLocalDataSource(sl()));
//     sl.registerLazySingleton<HiveCategoryLocalDataSource>(() => HiveCategoryLocalDataSource(sl()));
//
//     // Repositories
//     sl.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(sl()));
//     sl.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(sl()));
//
//     // Use Cases
//     sl.registerLazySingleton(() => AddTaskUseCase(sl()));
//     sl.registerLazySingleton(() => GetAllTasksUseCase(sl()));
//     sl.registerLazySingleton(() => DeleteTaskUseCase(sl()));
//     sl.registerLazySingleton(() => UpdateTaskUseCase(sl()));
//     sl.registerLazySingleton(() => GetTasksByStatusUseCase(sl()));
//     sl.registerLazySingleton(() => UpdateTaskStatusUseCase(sl()));
//     sl.registerLazySingleton(() => GetTasksByDateUseCase(sl()));
//     sl.registerLazySingleton(() => FilterTasksUseCase(sl()));
//
//     // Register Blocs
//     sl.registerFactory(() => TaskBloc(
//       getAllTasksUseCase: sl(),
//       addTaskUseCase: sl(),
//       updateTaskUseCase: sl(),
//       deleteTaskUseCase: sl(),
//       getTasksByStatusUseCase: sl(),
//       updateTaskStatusUseCase: sl(),
//       getTasksByDateUseCase: sl(),
//       filterTasksUseCase: sl(),
//     ));
//
//     sl.registerFactory(() => CategoryBloc(
//       addCategoryUseCase: sl(),
//       getAllCategoriesUseCase: sl(),
//       deleteCategoryUseCase: sl(),
//     ));
//   } catch (e, stackTrace) {
//     print("Error during DI initialization: $e");
//     print(stackTrace);
//   }
// }
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

