import 'package:get_it/get_it.dart';
import 'package:mapperapp/feature/PlanHome/data/dataSource/localData.dart';
import 'package:mapperapp/feature/PlanHome/domain/usecase/UpdateStatus_plan_usecase.dart';
import 'package:mapperapp/feature/PlanHome/domain/usecase/getByStatus_plan_useCase.dart';
import 'package:mapperapp/feature/taskHome/domain/usecse/task/getByPlanId_task_usecase.dart';
import '../feature/MainScreen/domain/task_usecase/filter_usecase.dart';
import '../feature/MainScreen/presentation/bloc/main_bloc.dart';
import '../feature/PlanHome/data/repo_impl/repoPlan.dart';
import '../feature/PlanHome/domain/repo_interface/repoPlanInterface.dart';
import '../feature/PlanHome/domain/usecase/add_plan_usecase.dart';
import '../feature/PlanHome/domain/usecase/delete_plan_useCase.dart';
import '../feature/PlanHome/domain/usecase/getAll_plan_usecase.dart';
import '../feature/PlanHome/domain/usecase/getByCatogery_plan_usecase.dart';
import '../feature/PlanHome/domain/usecase/update_plan_usecase.dart';
import '../feature/PlanHome/presentation/bloc/bloc.dart';
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

    // Register HiveCategoryLocalDataSource
    sl.registerLazySingleton<HivePlanLocalDataSource>(
      () => HivePlanLocalDataSource(sl<HiveService>()),
    );

    // Register TaskRepository
    sl.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImpl(sl<TaskLocalDataSource>()),
    );

    // Register CategoryRepository
    sl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(sl<HiveCategoryLocalDataSource>()),
    );

    sl.registerLazySingleton<PlanRepository>(
      () => PlanRepositoryImpl(sl<HivePlanLocalDataSource>()),
    );

    // Register Use Cases for Tasks
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
sl.registerLazySingleton(()=> GetTasksByPlanIdUseCase(sl<TaskRepository>()));

    // Register Use Cases for Categories
    sl.registerLazySingleton(
        () => AddCategoryUseCase(sl<CategoryRepository>()));
    sl.registerLazySingleton(
        () => GetAllCategoriesUseCase(sl<CategoryRepository>()));
    sl.registerLazySingleton(
        () => DeleteCategoryUseCase(sl<CategoryRepository>()));


// plan use case
    sl.registerLazySingleton(() => GetAllPlansUseCase(sl<PlanRepository>()));
    sl.registerLazySingleton(() => DeletePlanUseCase(sl<PlanRepository>()));
    sl.registerLazySingleton(
        () => GetPlansByCategoryUseCase(sl<PlanRepository>()));
    sl.registerLazySingleton(() => AddPlanUseCase(sl<PlanRepository>()));
    sl.registerLazySingleton(() => UpdatePlanUseCase(sl<PlanRepository>()));
    sl.registerLazySingleton(()=>GetPlansByStatusUseCase(sl<PlanRepository>()));
    sl.registerLazySingleton(() => UpdatePlanStatusUseCase(sl<PlanRepository>()));

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
          filterTasksUseCase: sl<FilterTasksUseCase>(), getTasksByPlanIdUseCase: sl<GetTasksByPlanIdUseCase>(),
        ));

    // Register CategoryBloc
    sl.registerFactory(() => CategoryBloc(
          addCategoryUseCase: sl<AddCategoryUseCase>(),
          getAllCategoriesUseCase: sl<GetAllCategoriesUseCase>(),
          deleteCategoryUseCase: sl<DeleteCategoryUseCase>(),
        ));
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
      updatePlanStatusUseCase: sl<UpdatePlanStatusUseCase>()
        ));
  } catch (e, stackTrace) {
    print("Error during DI initialization: $e");
    print(stackTrace);
  }
}
