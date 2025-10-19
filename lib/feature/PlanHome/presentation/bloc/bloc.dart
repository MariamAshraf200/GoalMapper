import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../injection_imports.dart';
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

  // 🔹 Task Use cases
  final GetAllTasksPlanUseCase getAllTasksPlanUseCase;
  final AddTaskPlanUseCase addTaskPlanUseCase;
  final DeleteTaskAtPlanUseCase deleteTaskAtPlanUseCase;
  final UpdateTaskStatusPlanUseCase updateTaskStatusPlanUseCase;

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
    on<GetAllPlansEvent>(_onGetAllPlans);
    on<AddPlanEvent>(_onAddPlan);
    on<UpdatePlanEvent>(_onUpdatePlan);
    on<DeletePlanEvent>(_onDeletePlan);
    on<GetPlansByCategoryEvent>(_onGetPlansByCategory);
    on<GetPlansByStatusEvent>(_onGetPlansByStatus);
    on<UpdatePlanStatusEvent>(_onUpdatePlanStatus);

    // ---------------- Tasks ----------------
    on<GetAllTasksPlanEvent>(_onGetAllTasks);
    on<AddTaskToPlanEvent>(_onAddTaskToPlan);
    on<DeleteTaskAtIndexEvent>(_onDeleteTaskAtIndex);
    on<ToggleTaskStatusEvent>(_onToggleTaskStatus);
    on<DeleteTaskFromPlanEvent>(_onDeleteTaskFromPlan);
  }


  // ---------------- Plans Handlers ----------------
  Future<void> _onGetAllPlans(GetAllPlansEvent event,
      Emitter<PlanState> emit) async {
    emit(PlanLoading());
    try {
      final plans = await getAllPlansUseCase();
      emit(PlanLoaded(plans));
    } catch (e) {
      emit(PlanError("Error loading plans: $e"));
    }
  }

  Future<void> _onAddPlan(AddPlanEvent event, Emitter<PlanState> emit) async {
    try {
      await addPlanUseCase(event.plan);
      final plans = await getAllPlansUseCase();
      _emitPlansWithTasksIfNeeded(plans, emit);
    } catch (e) {
      emit(PlanError("Error adding plan: $e"));
    }
  }

  Future<void> _onUpdatePlan(UpdatePlanEvent event,
      Emitter<PlanState> emit) async {
    try {
      await updatePlanUseCase(event.plan);
      final plans = await getAllPlansUseCase();

      if (state is PlanAndTasksLoaded) {
        final tasks = await getAllTasksPlanUseCase(event.plan.id);
        emit(PlanAndTasksLoaded(plans: plans, tasks: tasks));
      } else {
        emit(PlanLoaded(plans));
      }
    } catch (e) {
      emit(PlanError("Error updating plan: $e"));
    }
  }

  Future<void> _onDeletePlan(DeletePlanEvent event,
      Emitter<PlanState> emit) async {
    try {
      await deletePlanUseCase(event.planId);
      final plans = await getAllPlansUseCase();
      emit(PlanLoaded(plans));
    } catch (e) {
      emit(PlanError("Error deleting plan: $e"));
    }
  }

  Future<void> _onGetPlansByCategory(GetPlansByCategoryEvent event,
      Emitter<PlanState> emit) async {
    try {
      final plans = await getPlansByCategoryUseCase(event.category);
      emit(PlanLoaded(plans));
    } catch (e) {
      emit(PlanError("Error loading category: $e"));
    }
  }

  Future<void> _onGetPlansByStatus(GetPlansByStatusEvent event,
      Emitter<PlanState> emit) async {
    try {
      final plans = await getPlansByStatusUseCase(event.status);
      emit(PlanLoaded(plans));
    } catch (e) {
      emit(PlanError("Error loading status: $e"));
    }
  }

  Future<void> _onUpdatePlanStatus(UpdatePlanStatusEvent event,
      Emitter<PlanState> emit) async {
    try {
      await updatePlanStatusUseCase(event.planId, event.newStatus);
      final plans = await getAllPlansUseCase();
      emit(PlanLoaded(plans));
    } catch (e) {
      emit(PlanError("Error updating status: $e"));
    }
  }

  // ---------------- Tasks Handlers ----------------
  Future<void> _onGetAllTasks(GetAllTasksPlanEvent event,
      Emitter<PlanState> emit) async {
    await _reloadPlansAndTasks(event.planId, emit);
  }

  Future<void> _onAddTaskToPlan(AddTaskToPlanEvent event,
      Emitter<PlanState> emit) async {
    await _safeTaskOperation(
      event.planId,
          () => addTaskPlanUseCase(event.planId, event.task),
      emit,
    );
  }

  Future<void> _onDeleteTaskAtIndex(DeleteTaskAtIndexEvent event,
      Emitter<PlanState> emit) async {
    await _safeTaskOperation(
      event.planId,
          () => deleteTaskAtPlanUseCase(event.planId, event.index),
      emit,
    );
  }

  Future<void> _onToggleTaskStatus(ToggleTaskStatusEvent event,
      Emitter<PlanState> emit) async {
    final toggledTask = event.task.copyWith(
      status: event.task.status == TaskPlanStatus.toDo
          ? TaskPlanStatus.done
          : TaskPlanStatus.toDo,
    );

    await _safeTaskOperation(
      event.planId,
          () => updateTaskStatusPlanUseCase(event.planId, toggledTask),
      emit,
    );
  }

  Future<void> _onDeleteTaskFromPlan(DeleteTaskFromPlanEvent event,
      Emitter<PlanState> emit) async {
    await _safeTaskOperation(
      event.planId,
          () async {
        final tasks = await getAllTasksPlanUseCase(event.planId);
        final index = tasks.indexWhere((task) => task.id == event.taskId);
        if (index == -1) throw Exception('Task not found');
        await deleteTaskAtPlanUseCase(event.planId, index);
      },
      emit,
    );
  }

  // ---------------- Helpers ----------------

  /// 🔹 Helper to reload both plans and tasks after any task operation
  Future<void> _reloadPlansAndTasks(String planId,
      Emitter<PlanState> emit) async {
    emit(TasksLoading());
    try {
      final tasks = await getAllTasksPlanUseCase(planId);
      final updatedPlans = await _applyStatusUpdateAndGetPlans(planId, tasks);
      emit(PlanAndTasksLoaded(plans: updatedPlans, tasks: tasks));
    } catch (e) {
      emit(TaskError("Error loading tasks: $e"));
    }
  }

  /// 🔹 Wrapper to handle task operation safely then reload state
  Future<void> _safeTaskOperation(String planId,
      Future<void> Function() operation,
      Emitter<PlanState> emit,) async {
    emit(TasksLoading());
    try {
      await operation();
      final tasks = await getAllTasksPlanUseCase(planId);
      final updatedPlans = await _applyStatusUpdateAndGetPlans(planId, tasks);
      emit(PlanAndTasksLoaded(plans: updatedPlans, tasks: tasks));
    } catch (e) {
      emit(TaskError("Error in task operation: $e"));
    }
  }

  /// 🔹 Emit proper state depending on current state (keep tasks if already loaded)
  void _emitPlansWithTasksIfNeeded(List<PlanDetails> plans,
      Emitter<PlanState> emit) {
    if (state is PlanAndTasksLoaded) {
      final tasks = (state as PlanAndTasksLoaded).tasks;
      emit(PlanAndTasksLoaded(plans: plans, tasks: tasks));
    } else {
      emit(PlanLoaded(plans));
    }
  }

  /// 🔹 Update plan status/progress after tasks change
  Future<List<PlanDetails>> _applyStatusUpdateAndGetPlans(String planId,
      List<TaskPlan> tasks) async {
    final plans = await getAllPlansUseCase();
    final plan = plans.firstWhere((p) => p.id == planId);

    final allDone = tasks.isNotEmpty &&
        tasks.every((t) => t.status == TaskPlanStatus.done);
    final progress = tasks.isEmpty
        ? 0.0
        : (tasks
        .where((t) => t.status == TaskPlanStatus.done)
        .length / tasks.length) * 100.0;

    final shouldBeCompleted = allDone || (progress >= 100.0);
    final newStatus = shouldBeCompleted ? 'Completed' : 'Not Completed';

    final updatedPlan = plan.copyWith(
      status: newStatus,
      completed: shouldBeCompleted,
      progress: shouldBeCompleted ? 100.0 : progress,
    );

    if (updatedPlan != plan) {
      await updatePlanUseCase(updatedPlan);
    }

    return getAllPlansUseCase();
  }
}