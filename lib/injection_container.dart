import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'feature/PlanHome/data/dataSource/abstractLocalDataSource.dart';
import 'feature/auth/domain/repositories/auth_repository.dart';
import 'injection_imports.dart';

final sl = GetIt.instance;

/// Initializes all dependency injection modules in a clean, modular way.
Future<void> init() async {
  try {
    // ─────────────────────────────── HIVE INITIALIZATION ───────────────────────────────
    await _initHiveModule();

    // ─────────────────────────────── TASK FEATURE ───────────────────────────────
    _initTaskFeature();

    // ─────────────────────────────── CATEGORY FEATURE ───────────────────────────────
    _initCategoryFeature();

    // ─────────────────────────────── PLAN FEATURE ───────────────────────────────
    _initPlanFeature();

    // ─────────────────────────────── HOME FEATURE ───────────────────────────────
    _initHomeFeature();

    // ─────────────────────────────── AUTH FEATURE ───────────────────────────────
    _initAuthFeature();

  } catch (e, stack) {
    debugPrint('[DI ERROR] $e');
    debugPrint(stack.toString());
    rethrow;
  }
}

// ─────────────────────────────── HIVE MODULE ───────────────────────────────
Future<void> _initHiveModule() async {
  sl.registerLazySingleton(() => HiveService());
  await sl<HiveService>().initHive();
}

// ─────────────────────────────── TASK FEATURE ───────────────────────────────
void _initTaskFeature() {
  // Data Source
  sl.registerLazySingleton<TaskLocalDataSource>(
        () => HiveTaskLocalDataSource(sl()),
  );

  // Repository
  sl.registerLazySingleton<TaskRepository>(
        () => TaskRepositoryImpl(sl()),
  );

  // Use Cases
  sl
    ..registerLazySingleton(() => AddTaskUseCase(sl()))
    ..registerLazySingleton(() => GetAllTasksUseCase(sl()))
    ..registerLazySingleton(() => DeleteTaskUseCase(sl()))
    ..registerLazySingleton(() => UpdateTaskUseCase(sl()))
    ..registerLazySingleton(() => GetTasksByStatusUseCase(sl()))
    ..registerLazySingleton(() => GetTasksByPriorityUseCase(sl()))
    ..registerLazySingleton(() => UpdateTaskStatusUseCase(sl()))
    ..registerLazySingleton(() => GetTasksByDateUseCase(sl()))
    ..registerLazySingleton(() => FilterTasksUseCase(sl()))
    ..registerLazySingleton(() => GetTasksByPlanIdUseCase(sl()));

  // Bloc
  sl.registerFactory(() => TaskBloc(
    getAllTasksUseCase: sl(),
    addTaskUseCase: sl(),
    updateTaskUseCase: sl(),
    deleteTaskUseCase: sl(),
    getTasksByStatusUseCase: sl(),
    getTasksByPriorityUseCase: sl(),
    updateTaskStatusUseCase: sl(),
    getTasksByDateUseCase: sl(),
    filterTasksUseCase: sl(),
    getTasksByPlanIdUseCase: sl(),
  ));
}

// ─────────────────────────────── CATEGORY FEATURE ───────────────────────────────
void _initCategoryFeature() {
  sl.registerLazySingleton<CategoryLocalDataSource>(
        () => HiveCategoryLocalDataSource(sl()),
  );

  sl.registerLazySingleton<CategoryRepository>(
        () => CategoryRepositoryImpl(sl()),
  );

  sl
    ..registerLazySingleton(() => AddCategoryUseCase(sl()))
    ..registerLazySingleton(() => GetAllCategoriesUseCase(sl()))
    ..registerLazySingleton(() => DeleteCategoryUseCase(sl()));

  sl.registerFactory(() => CategoryBloc(
    addCategoryUseCase: sl(),
    getAllCategoriesUseCase: sl(),
    deleteCategoryUseCase: sl(),
  ));
}

// ─────────────────────────────── PLAN FEATURE ───────────────────────────────
void _initPlanFeature() {
  sl.registerLazySingleton<PlanLocalDataSource>(
        () => HivePlanLocalDataSource(sl()),
  );

  sl.registerLazySingleton<PlanRepository>(
        () => PlanRepositoryImpl(sl()),
  );

  sl
    ..registerLazySingleton(() => GetAllPlansUseCase(sl()))
    ..registerLazySingleton(() => DeletePlanUseCase(sl()))
    ..registerLazySingleton(() => GetPlansByCategoryUseCase(sl()))
    ..registerLazySingleton(() => AddPlanUseCase(sl()))
    ..registerLazySingleton(() => UpdatePlanUseCase(sl()))
    ..registerLazySingleton(() => GetPlansByStatusUseCase(sl()))
    ..registerLazySingleton(() => UpdatePlanStatusUseCase(sl()))
    ..registerLazySingleton(() => GetAllTasksPlanUseCase(sl()))
    ..registerLazySingleton(() => AddTaskPlanUseCase(sl()))
    ..registerLazySingleton(() => DeleteTaskAtPlanUseCase(sl()))
    ..registerLazySingleton(() => UpdateTaskStatusPlanUseCase(sl()));

  sl.registerFactory(() => PlanBloc(
    getAllPlansUseCase: sl(),
    addPlanUseCase: sl(),
    updatePlanUseCase: sl(),
    deletePlanUseCase: sl(),
    getPlansByCategoryUseCase: sl(),
    getPlansByStatusUseCase: sl(),
    updatePlanStatusUseCase: sl(),
    getAllTasksPlanUseCase: sl(),
    addTaskPlanUseCase: sl(),
    deleteTaskAtPlanUseCase: sl(),
    updateTaskStatusPlanUseCase: sl(),
  ));
}

// ─────────────────────────────── HOME FEATURE ───────────────────────────────
void _initHomeFeature() {
  sl
    ..registerLazySingleton(() => ComputeWeeklyProgressUsecase())
    ..registerLazySingleton(() => UpdateDailyProgressUsecase());
}

// ─────────────────────────────── AUTH FEATURE ───────────────────────────────
void _initAuthFeature() {
  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  // Usecases
  sl
    ..registerLazySingleton(() => SignInWithGoogle(sl<AuthRepository>()))
    ..registerLazySingleton(() => SignOut(sl<AuthRepository>()))
    ..registerLazySingleton(() => GetCurrentUser(sl<AuthRepository>()));

  // Bloc
  sl.registerFactory(() => AuthBloc(
    signInWithGoogle: sl(),
    signOut: sl(),
    getCurrentUser: sl(),
  ));
}
