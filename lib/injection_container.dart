import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'injection_imports.dart';

final sl = GetIt.instance;

Future<void> init() async {
  try {
    ///////////////////////// Hive //////////////////////////////
    ////////////////////////////////////////////////////////////
    // Register HiveService
    sl.registerLazySingleton<HiveService>(() => HiveService());

    // Initialize Hive
    final hiveService = sl<HiveService>();
    await hiveService.initHive();

    ///////////////////////// Data sources (Hive-backed) /////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////

    // Register HiveTaskLocalDataSource
    sl.registerLazySingleton<TaskLocalDataSource>(
      () => HiveTaskLocalDataSource(sl<HiveService>()),
    );

    // Register HiveCategoryLocalDataSource
    sl.registerLazySingleton<CategoryLocalDataSource>(
      () => HiveCategoryLocalDataSource(sl<HiveService>()),
    );

    // Register HivePlanLocalDataSource
    sl.registerLazySingleton<HivePlanLocalDataSource>(
      () => HivePlanLocalDataSource(sl<HiveService>()),
    );

    ///////////////////////// Repositories /////////////////////////////
    ///////////////////////////////////////////////////////////////////

    // Register TaskRepository
    sl.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImpl(sl<TaskLocalDataSource>()),
    );

    // Register CategoryRepository
    sl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(sl<CategoryLocalDataSource>()),
    );

    // Register PlanRepository
    sl.registerLazySingleton<PlanRepository>(
      () => PlanRepositoryImpl(sl<HivePlanLocalDataSource>()),
    );

    ///////////////////////// Use Cases - Tasks /////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    sl.registerLazySingleton(() => AddTaskUseCase(sl<TaskRepository>()));
    sl.registerLazySingleton(() => GetAllTasksUseCase(sl<TaskRepository>()));
    sl.registerLazySingleton(() => DeleteTaskUseCase(sl<TaskRepository>()));
    sl.registerLazySingleton(() => UpdateTaskUseCase(sl<TaskRepository>()));
    sl.registerLazySingleton(
        () => GetTasksByStatusUseCase(sl<TaskRepository>()));
    sl.registerLazySingleton(
        () => GetTasksByPriorityUseCase(sl<TaskRepository>()));
    sl.registerLazySingleton(
        () => UpdateTaskStatusUseCase(sl<TaskRepository>()));
    sl.registerLazySingleton(() => GetTasksByDateUseCase(sl<TaskRepository>()));
    sl.registerLazySingleton(() => FilterTasksUseCase(sl<TaskRepository>()));
    sl.registerLazySingleton(
        () => FilterMainTasksUseCase(sl<TaskRepository>()));
    sl.registerLazySingleton(
        () => GetTasksByPlanIdUseCase(sl<TaskRepository>()));

    ///////////////////////// Use Cases - Categories /////////////////////////////
    //////////////////////////////////////////////////////////////////////////////

    sl.registerLazySingleton(
        () => AddCategoryUseCase(sl<CategoryRepository>()));
    sl.registerLazySingleton(
        () => GetAllCategoriesUseCase(sl<CategoryRepository>()));
    sl.registerLazySingleton(
        () => DeleteCategoryUseCase(sl<CategoryRepository>()));

    ///////////////////////// Use Cases - Plans /////////////////////////////
    /////////////////////////////////////////////////////////////////////////

    sl.registerLazySingleton(() => GetAllPlansUseCase(sl<PlanRepository>()));
    sl.registerLazySingleton(() => DeletePlanUseCase(sl<PlanRepository>()));
    sl.registerLazySingleton(
        () => GetPlansByCategoryUseCase(sl<PlanRepository>()));
    sl.registerLazySingleton(() => AddPlanUseCase(sl<PlanRepository>()));
    sl.registerLazySingleton(() => UpdatePlanUseCase(sl<PlanRepository>()));
    sl.registerLazySingleton(
        () => GetPlansByStatusUseCase(sl<PlanRepository>()));
    sl.registerLazySingleton(
        () => UpdatePlanStatusUseCase(sl<PlanRepository>()));

    ///////////////////////// Blocs / Cubits /////////////////////////////
    /////////////////////////////////////////////////////////////////////

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
          getTasksByPlanIdUseCase: sl<GetTasksByPlanIdUseCase>(),
        ));

    // Register CategoryBloc
    sl.registerFactory(() => CategoryBloc(
          addCategoryUseCase: sl<AddCategoryUseCase>(),
          getAllCategoriesUseCase: sl<GetAllCategoriesUseCase>(),
          deleteCategoryUseCase: sl<DeleteCategoryUseCase>(),
        ));

    // Register MainTaskBloc
    sl.registerFactory(() => MainTaskBloc(
          filterTasksUseCase: sl<FilterMainTasksUseCase>(),
        ));

    // Register PlanBloc
    sl.registerFactory(() => PlanBloc(
        getAllPlansUseCase: sl<GetAllPlansUseCase>(),
        addPlanUseCase: sl<AddPlanUseCase>(),
        updatePlanUseCase: sl<UpdatePlanUseCase>(),
        deletePlanUseCase: sl<DeletePlanUseCase>(),
        getPlansByCategoryUseCase: sl<GetPlansByCategoryUseCase>(),
        getPlansByStatusUseCase: sl<GetPlansByStatusUseCase>(),
        updatePlanStatusUseCase: sl<UpdatePlanStatusUseCase>()));
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print("Error during DI initialization: $e");
    }
    if (kDebugMode) {
      print(stackTrace);
    }
  }
}
