import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../injection_imports.dart';

class PlanBloc extends Bloc<PlanEvent, PlanState> {
  final GetAllPlansUseCase getAllPlansUseCase;
  final AddPlanUseCase addPlanUseCase;
  final UpdatePlanUseCase updatePlanUseCase;
  final DeletePlanUseCase deletePlanUseCase;
  final GetPlansByCategoryUseCase getPlansByCategoryUseCase;
  final GetPlansByStatusUseCase getPlansByStatusUseCase;
  final UpdatePlanStatusUseCase updatePlanStatusUseCase;

  PlanBloc({
    required this.getAllPlansUseCase,
    required this.addPlanUseCase,
    required this.updatePlanUseCase,
    required this.deletePlanUseCase,
    required this.getPlansByCategoryUseCase,
    required this.getPlansByStatusUseCase,
    required this.updatePlanStatusUseCase,
  }) : super(PlanInitial()) {
    on<GetAllPlansEvent>(_handleGetAllPlans);
    on<AddPlanEvent>(_handleAddPlan);
    on<UpdatePlanEvent>(_handleUpdatePlan);
    on<DeletePlanEvent>(_handleDeletePlan);
    on<GetPlansByCategoryEvent>(_handleGetPlansByCategory);
    on<GetPlansByStatusEvent>(_handleGetPlansByStatus);
    on<UpdatePlanStatusEvent>(_handleUpdatePlanStatus);
  }

  /// Common executor for async operations with error handling
  Future<void> _execute(
      Emitter<PlanState> emit,
      Future<void> Function() action, {
        PlanState? previousState,
        bool reloadAfter = false,
      }) async {
    emit(PlanLoading());
    try {
      await action();
      if (reloadAfter) {
        final plans = await getAllPlansUseCase();
        emit(PlanLoaded(plans));
      }
    } catch (e) {
      if (previousState != null) emit(previousState);
      emit(PlanError("Error: $e"));
    }
  }

  // ---------------- Event Handlers ----------------

  Future<void> _handleGetAllPlans(
      GetAllPlansEvent event,
      Emitter<PlanState> emit,
      ) async {
    await _execute(emit, () async {
      final plans = await getAllPlansUseCase();
      emit(PlanLoaded(plans));
    });
  }

  Future<void> _handleAddPlan(
      AddPlanEvent event,
      Emitter<PlanState> emit,
      ) async {
    await _execute(
      emit,
          () => addPlanUseCase(event.plan),
      previousState: state,
      reloadAfter: true,
    );
  }

  Future<void> _handleUpdatePlan(
      UpdatePlanEvent event,
      Emitter<PlanState> emit,
      ) async {
    await _execute(
      emit,
          () => updatePlanUseCase(event.plan),
      previousState: state,
      reloadAfter: true,
    );
  }

  Future<void> _handleDeletePlan(
      DeletePlanEvent event,
      Emitter<PlanState> emit,
      ) async {
    await _execute(
      emit,
          () => deletePlanUseCase(event.planId),
      previousState: state,
      reloadAfter: true,
    );
  }

  Future<void> _handleGetPlansByCategory(
      GetPlansByCategoryEvent event,
      Emitter<PlanState> emit,
      ) async {
    await _execute(emit, () async {
      final plans = await getPlansByCategoryUseCase(event.category);
      emit(PlanLoaded(plans));
    });
  }

  Future<void> _handleGetPlansByStatus(
      GetPlansByStatusEvent event,
      Emitter<PlanState> emit,
      ) async {
    await _execute(emit, () async {
      final plans = await getPlansByStatusUseCase(event.status);
      emit(PlanLoaded(plans));
    });
  }

  Future<void> _handleUpdatePlanStatus(
      UpdatePlanStatusEvent event,
      Emitter<PlanState> emit,
      ) async {
    await _execute(
      emit,
          () => updatePlanStatusUseCase(event.planId, event.newStatus),
      previousState: state,
      reloadAfter: true,
    );
  }
}
