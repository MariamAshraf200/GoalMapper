import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapperapp/feature/PlanHome/presentation/bloc/state.dart';
import '../../domain/usecase/add_plan_usecase.dart';
import '../../domain/usecase/delete_plan_useCase.dart';
import '../../domain/usecase/getAll_plan_usecase.dart';
import '../../domain/usecase/getByCatogery_plan_usecase.dart';
import '../../domain/usecase/getByStatus_plan_useCase.dart';
import '../../domain/usecase/update_plan_usecase.dart';
import 'event.dart';

class PlanBloc extends Bloc<PlanEvent, PlanState> {
  final GetAllPlansUseCase getAllPlansUseCase;
  final AddPlanUseCase addPlanUseCase;
  final UpdatePlanUseCase updatePlanUseCase;
  final DeletePlanUseCase deletePlanUseCase;
  final GetPlansByCategoryUseCase getPlansByCategoryUseCase;
  final GetPlansByStatusUseCase getPlansByStatusUseCase;

  PlanBloc({
    required this.getAllPlansUseCase,
    required this.addPlanUseCase,
    required this.updatePlanUseCase,
    required this.deletePlanUseCase,
    required this.getPlansByCategoryUseCase,
    required this.getPlansByStatusUseCase,
  }) : super(PlanInitial()) {
    on<GetAllPlansEvent>(_onGetAllPlans);
    on<AddPlanEvent>(_onAddPlan);
    on<UpdatePlanEvent>(_onUpdatePlan);
    on<DeletePlanEvent>(_onDeletePlan);
    on<GetPlansByCategoryEvent>(_onGetPlansByCategory);
    on<GetPlansByStatusEvent>(_onGetPlansByStatus);
  }

  // Fetch all plans
  Future<void> _onGetAllPlans(
      GetAllPlansEvent event,
      Emitter<PlanState> emit,
      ) async {
    emit(PlanLoading());
    try {
      final plans = await getAllPlansUseCase();
      emit(PlanLoaded(plans));
    } catch (e) {
      emit(PlanError("Failed to load all plans: ${e.toString()}"));
    }
  }

  // Add a new plan
  Future<void> _onAddPlan(
      AddPlanEvent event,
      Emitter<PlanState> emit,
      ) async {
    final previousState = state;
    emit(PlanLoading());
    try {
      await addPlanUseCase(event.plan);
      await _reloadPlans(emit);
    } catch (e) {
      emit(previousState); // Restore previous state on error
      emit(PlanError("Failed to add plan: ${e.toString()}"));
    }
  }

  // Update an existing plan
  Future<void> _onUpdatePlan(
      UpdatePlanEvent event,
      Emitter<PlanState> emit,
      ) async {
    final previousState = state;
    emit(PlanLoading());
    try {
      await updatePlanUseCase(event.plan);
      await _reloadPlans(emit);
    } catch (e) {
      emit(previousState); // Restore previous state on error
      emit(PlanError("Failed to update plan: ${e.toString()}"));
    }
  }

  // Delete a plan
  Future<void> _onDeletePlan(
      DeletePlanEvent event,
      Emitter<PlanState> emit,
      ) async {
    final previousState = state;
    emit(PlanLoading());
    try {
      await deletePlanUseCase(event.planId);
      await _reloadPlans(emit);
    } catch (e) {
      emit(previousState); // Restore previous state on error
      emit(PlanError("Failed to delete plan: ${e.toString()}"));
    }
  }

  // Fetch plans by category
  Future<void> _onGetPlansByCategory(
      GetPlansByCategoryEvent event,
      Emitter<PlanState> emit,
      ) async {
    emit(PlanLoading());
    try {
      final plans = await getPlansByCategoryUseCase(event.category);
      emit(PlanLoaded(plans));
    } catch (e) {
      emit(PlanError("Failed to load plans by category: ${e.toString()}"));
    }
  }

  // Fetch plans by status
  Future<void> _onGetPlansByStatus(
      GetPlansByStatusEvent event,
      Emitter<PlanState> emit,
      ) async {
    emit(PlanLoading());
    try {
      final plans = await getPlansByStatusUseCase(event.status);
      emit(PlanLoaded(plans));
    } catch (e) {
      emit(PlanError("Failed to load plans by status: ${e.toString()}"));
    }
  }

  // Utility function to reload plans after a mutation
  Future<void> _reloadPlans(Emitter<PlanState> emit) async {
    try {
      final plans = await getAllPlansUseCase();
      emit(PlanLoaded(plans));
    } catch (e) {
      emit(PlanError("Failed to reload plans: ${e.toString()}"));
    }
  }
}
