import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../injection_imports.dart';
import '../../domain/entities/taskPlan.dart';
import '../../domain/usecase/delet_task_plan.dart';
import '../../domain/usecase/getAll_tasks_plan_usecase.dart';
import '../../domain/usecase/update_task_status_plan.dart';

class PlanBloc extends Bloc<PlanEvent, PlanState> {
  final GetAllPlansUseCase getAllPlansUseCase;
  final AddPlanUseCase addPlanUseCase;
  final UpdatePlanUseCase updatePlanUseCase;
  final DeletePlanUseCase deletePlanUseCase;
  final GetPlansByCategoryUseCase getPlansByCategoryUseCase;
  final GetPlansByStatusUseCase getPlansByStatusUseCase;
  final UpdatePlanStatusUseCase updatePlanStatusUseCase;

  // 🔹 Use cases for tasks
  final GetAllTasksPlanUseCase getAllTasksPlanUseCase;
  final AddTaskPlanUseCase addTaskPlanUseCase;
  final DeleteTaskAtPlanUseCase deleteTaskAtPlanUseCase;
  final UpdateTaskStatusPlanUseCase updateTaskStatusPlanUseCase ;

  PlanBloc({
    required this.getAllPlansUseCase,
    required this.addPlanUseCase,
    required this.updatePlanUseCase,
    required this.deletePlanUseCase,
    required this.getPlansByCategoryUseCase,
    required this.getPlansByStatusUseCase,
    required this.updatePlanStatusUseCase,
    required this.getAllTasksPlanUseCase,
    required this.addTaskPlanUseCase,
    required this.deleteTaskAtPlanUseCase,
    required this.updateTaskStatusPlanUseCase,
  }) : super(PlanInitial()) {
    // ---------------- Plans ----------------
    on<GetAllPlansEvent>(_handleGetAllPlans);
    on<AddPlanEvent>(_handleAddPlan);
    on<UpdatePlanEvent>(_handleUpdatePlan);
    on<DeletePlanEvent>(_handleDeletePlan);
    on<GetPlansByCategoryEvent>(_handleGetPlansByCategory);
    on<GetPlansByStatusEvent>(_handleGetPlansByStatus);
    on<UpdatePlanStatusEvent>(_handleUpdatePlanStatus);

    // ---------------- Tasks ----------------
    on<GetAllTasksPlanEvent>(_handleGetAllTasks);
    on<AddTaskToPlanEvent>(_handleAddTaskToPlan);
    on<DeleteTaskAtIndexEvent>(_handleDeleteTaskAtIndex);
    on<ToggleTaskStatusEvent>(_handleToggleTaskStatus);
    on<DeleteTaskFromPlanEvent>(_handleDeleteTaskFromPlan);
  }





  // ---------------- Plans ----------------
  Future<void> _handleGetAllPlans(
      GetAllPlansEvent event,
      Emitter<PlanState> emit,
      ) async {
    emit(PlanLoading());
    try {
      final plans = await getAllPlansUseCase();
      emit(PlanLoaded(plans));
    } catch (e) {
      emit(PlanError("Error loading plans: $e"));
    }
  }

  Future<void> _handleAddPlan(
      AddPlanEvent event,
      Emitter<PlanState> emit,
      ) async {
    try {
      await addPlanUseCase(event.plan);
      final plans = await getAllPlansUseCase();
      emit(PlanLoaded(plans));
    } catch (e) {
      emit(PlanError("Error adding plan: $e"));
    }
  }

  Future<void> _handleUpdatePlan(
      UpdatePlanEvent event,
      Emitter<PlanState> emit,
      ) async {
    try {
      await updatePlanUseCase(event.plan);
      final plans = await getAllPlansUseCase();
      emit(PlanLoaded(plans));
    } catch (e) {
      emit(PlanError("Error updating plan: $e"));
    }
  }

  Future<void> _handleDeletePlan(
      DeletePlanEvent event,
      Emitter<PlanState> emit,
      ) async {
    try {
      await deletePlanUseCase(event.planId);
      final plans = await getAllPlansUseCase();
      emit(PlanLoaded(plans));
    } catch (e) {
      emit(PlanError("Error deleting plan: $e"));
    }
  }

  Future<void> _handleGetPlansByCategory(
      GetPlansByCategoryEvent event,
      Emitter<PlanState> emit,
      ) async {
    try {
      final plans = await getPlansByCategoryUseCase(event.category);
      emit(PlanLoaded(plans));
    } catch (e) {
      emit(PlanError("Error loading category: $e"));
    }
  }

  Future<void> _handleGetPlansByStatus(
      GetPlansByStatusEvent event,
      Emitter<PlanState> emit,
      ) async {
    try {
      final plans = await getPlansByStatusUseCase(event.status);
      emit(PlanLoaded(plans));
    } catch (e) {
      emit(PlanError("Error loading status: $e"));
    }
  }

  Future<void> _handleUpdatePlanStatus(
      UpdatePlanStatusEvent event,
      Emitter<PlanState> emit,
      ) async {
    try {
      await updatePlanStatusUseCase(event.planId, event.newStatus);
      final plans = await getAllPlansUseCase();
      emit(PlanLoaded(plans));
    } catch (e) {
      emit(PlanError("Error updating status: $e"));
    }
  }

  // ---------------- Tasks ----------------
  Future<void> _handleGetAllTasks(
      GetAllTasksPlanEvent event,
      Emitter<PlanState> emit,
      ) async {
    emit(TasksLoading());
    try {
      final tasks = await getAllTasksPlanUseCase(event.planId);
      final plans = await getAllPlansUseCase();
      emit(PlanAndTasksLoaded(plans: plans, tasks: tasks));
    } catch (e) {
      emit(TaskError("Error loading tasks: $e"));
    }
  }

  Future<void> _handleAddTaskToPlan(
      AddTaskToPlanEvent event,
      Emitter<PlanState> emit,
      ) async {
    emit(TasksLoading());
    try {
      await addTaskPlanUseCase(event.planId, event.task);
      final tasks = await getAllTasksPlanUseCase(event.planId);
      final plans = await getAllPlansUseCase();
      emit(PlanAndTasksLoaded(plans: plans, tasks: tasks));
    } catch (e) {
      emit(TaskError("Error adding task: $e"));
    }
  }

  Future<void> _handleDeleteTaskAtIndex(
      DeleteTaskAtIndexEvent event,
      Emitter<PlanState> emit,
      ) async {
    emit(TasksLoading());
    try {
      await deleteTaskAtPlanUseCase(event.planId, event.index);
      final tasks = await getAllTasksPlanUseCase(event.planId);
      final plans = await getAllPlansUseCase();
      emit(PlanAndTasksLoaded(plans: plans, tasks: tasks));
    } catch (e) {
      emit(TaskError("Error deleting task: $e"));
    }
  }


  Future<void> _handleToggleTaskStatus(
      ToggleTaskStatusEvent event,
      Emitter<PlanState> emit,
      ) async {
    emit(TasksLoading());
    try {
      final toggledTask = event.task.copyWith(
        status: event.task.status == TaskPlanStatus.toDo
            ? TaskPlanStatus.done
            : TaskPlanStatus.toDo,
      );

      await updateTaskStatusPlanUseCase(event.planId, toggledTask);

      final tasks = await getAllTasksPlanUseCase(event.planId);
      final plans = await getAllPlansUseCase();
      emit(PlanAndTasksLoaded(plans: plans, tasks: tasks));
    } catch (e) {
      emit(TaskError("Error toggling task: $e"));
    }
  }

  // Handler for deleting a task by ID
  Future<void> _handleDeleteTaskFromPlan(
      DeleteTaskFromPlanEvent event,
      Emitter<PlanState> emit,
      ) async {
    emit(TasksLoading());
    try {
      // Get all tasks for the plan
      final tasks = await getAllTasksPlanUseCase(event.planId);
      // Find the index of the task with the given taskId
      final index = tasks.indexWhere((task) => task.id == event.taskId);
      if (index == -1) throw Exception('Task not found');
      await deleteTaskAtPlanUseCase(event.planId, index);
      final updatedTasks = await getAllTasksPlanUseCase(event.planId);
      final plans = await getAllPlansUseCase();
      emit(PlanAndTasksLoaded(plans: plans, tasks: updatedTasks));
    } catch (e) {
      emit(TaskError("Error deleting task: $e"));
    }
  }

}
