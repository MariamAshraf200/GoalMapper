import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../injection_imports.dart';
import 'state.dart';

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
}
