import 'package:equatable/equatable.dart';


import '../../data/model/planModel.dart';
import '../../domain/entities/plan_entity.dart';

abstract class PlanState extends Equatable {
  const PlanState();

  @override
  List<Object?> get props => [];
}

class PlanInitial extends PlanState {}

class PlanLoading extends PlanState {}

class PlanLoaded extends PlanState {
  final List<PlanDetails> plans;
  final String? status;

  const PlanLoaded(this.plans, {this.status});

  @override
  List<Object?> get props => [plans, status];
}



class PlanError extends PlanState {
  final String message;

  const PlanError(this.message);

  @override
  List<Object?> get props => [message];
}

class PlanActionSuccess extends PlanState {
  final String message;

  const PlanActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PlanAddSuccess extends PlanState {
  final String message;
  final PlanModel plan;

  const PlanAddSuccess(this.message, this.plan);

  @override
  List<Object?> get props => [message, plan];
}
