import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapperapp/feature/PlanHome/presentation/bloc/state.dart';
import '../../domain/entities/plan_entity.dart';
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

  Future<void> _onGetAllPlans(
      GetAllPlansEvent event,
      Emitter<PlanState> emit,
      ) async {
    emit(PlanLoading());
    try {
      final plans = await getAllPlansUseCase();
      emit(PlanLoaded(plans));
    } catch (e) {
      emit(PlanError("Failed to load plans: $e"));
    }
  }

  Future<void> _onAddPlan(
      AddPlanEvent event,
      Emitter<PlanState> emit,
      ) async {
    PlanLoaded? previousState;

    try {
      if (state is PlanLoaded) {
        previousState = state as PlanLoaded;
        final updatedPlans = List<PlanDetails>.from(previousState.plans)
          ..add(event.plan);
        emit(PlanLoaded(updatedPlans));
      }

      await addPlanUseCase(event.plan);

      final plans = await getAllPlansUseCase();
      emit(PlanLoaded(plans));
    } catch (e) {
      if (previousState != null) {
        emit(previousState);
      }
      emit(PlanError("Failed to add plan: $e"));
    }
  }

  Future<void> _onUpdatePlan(
      UpdatePlanEvent event,
      Emitter<PlanState> emit,
      ) async {
    PlanLoaded? previousState;

    try {
      if (state is PlanLoaded) {
        previousState = state as PlanLoaded;
        final updatedPlans = previousState.plans.map((plan) {
          return plan.id == event.plan.id ? event.plan : plan;
        }).toList();
        emit(PlanLoaded(updatedPlans));
      }

      await updatePlanUseCase(event.plan);

      final plans = await getAllPlansUseCase();
      emit(PlanLoaded(plans));
    } catch (e) {
      if (previousState != null) {
        emit(previousState);
      }
      emit(PlanError("Failed to update plan: $e"));
    }
  }

  Future<void> _onDeletePlan(
      DeletePlanEvent event,
      Emitter<PlanState> emit,
      ) async {
    PlanLoaded? previousState;

    try {
      if (state is PlanLoaded) {
        previousState = state as PlanLoaded;
        final updatedPlans = previousState.plans
            .where((plan) => plan.id != event.planId)
            .toList();
        emit(PlanLoaded(updatedPlans));
      }

      await deletePlanUseCase(event.planId);

      final plans = await getAllPlansUseCase();
      emit(PlanLoaded(plans));
    } catch (e) {
      if (previousState != null) {
        emit(previousState);
      }
      emit(PlanError("Failed to delete plan: $e"));
    }
  }

  Future<void> _onGetPlansByCategory(
      GetPlansByCategoryEvent event,
      Emitter<PlanState> emit,
      ) async {
    emit(PlanLoading());
    try {
      final plans = await getPlansByCategoryUseCase(event.category);
      emit(PlanLoaded(plans));
    } catch (e) {
      emit(PlanError("Failed to load plans by category: $e"));
    }
  }

  Future<void> _onGetPlansByStatus(
      GetPlansByStatusEvent event,
      Emitter<PlanState> emit,
      ) async {
    emit(PlanLoading());
    try {
      final plans = await getPlansByStatusUseCase(event.status);
      emit(PlanLoaded(plans));
    } catch (e) {
      emit(PlanError("Failed to load plans by status: $e"));
    }
  }
}
