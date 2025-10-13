import 'package:get_it/get_it.dart';
import 'feature/Home/domain/usecase/compute_weekly_progress_usecase.dart';
import 'feature/Home/domain/usecase/update_daily_progress_usecase.dart';
import 'feature/PlanHome/domain/repo_interface/repo_plan_interface.dart';
import 'feature/PlanHome/domain/usecase/delet_task_plan.dart';
import 'feature/PlanHome/domain/usecase/getAll_tasks_plan_usecase.dart';
import 'feature/PlanHome/domain/usecase/update_task_status_plan.dart';
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
    // Plan task use cases
    sl.registerLazySingleton(() => GetAllTasksPlanUseCase(sl<PlanRepository>()));
    sl.registerLazySingleton(() => AddTaskPlanUseCase(sl<PlanRepository>()));
    sl.registerLazySingleton(() => DeleteTaskAtPlanUseCase(sl<PlanRepository>()));
    sl.registerLazySingleton(() => UpdateTaskStatusPlanUseCase(sl<PlanRepository>()));

    // Home usecases
    sl.registerLazySingleton(() => ComputeWeeklyProgressUsecase());
    sl.registerLazySingleton(() => UpdateDailyProgressUsecase());

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

    // Register PlanBloc
    sl.registerFactory(() => PlanBloc(
        getAllPlansUseCase: sl<GetAllPlansUseCase>(),
        addPlanUseCase: sl<AddPlanUseCase>(),
        updatePlanUseCase: sl<UpdatePlanUseCase>(),
        deletePlanUseCase: sl<DeletePlanUseCase>(),
        getPlansByCategoryUseCase: sl<GetPlansByCategoryUseCase>(),
        getPlansByStatusUseCase: sl<GetPlansByStatusUseCase>(),
        updatePlanStatusUseCase: sl<UpdatePlanStatusUseCase>(),
        getAllTasksPlanUseCase: sl<GetAllTasksPlanUseCase>(),
        addTaskPlanUseCase: sl<AddTaskPlanUseCase>(),
        deleteTaskAtPlanUseCase: sl<DeleteTaskAtPlanUseCase>(),
        updateTaskStatusPlanUseCase: sl<UpdateTaskStatusPlanUseCase>(),
      ));
  } catch (e, stackTrace) {
    /*if (kDebugMode) {
      debugPrint("Error during DI initialization: $e");
    }
    if (kDebugMode) {
      debugPrint(stackTrace.toString());
    }*/
  }
}
