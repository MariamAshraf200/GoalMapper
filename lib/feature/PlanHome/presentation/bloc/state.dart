import 'package:equatable/equatable.dart';
import '../../data/model/planModel.dart';
import '../../domain/entities/plan_entity.dart';
import '../../domain/entities/taskPlan.dart';

abstract class PlanState extends Equatable {
  const PlanState();

  @override
  List<Object?> get props => [];
}

// 🔹 Plans States
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

// 🔹 Tasks States
class TasksLoading extends PlanState {}

class TasksLoaded extends PlanState {
  final List<TaskPlan> tasks;
  const TasksLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TaskActionSuccess extends PlanState {
  final String message;
  const TaskActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class TaskError extends PlanState {
  final String message;
  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}


class PlanAndTasksLoaded extends PlanState {
  final List<PlanDetails> plans;
  final List<TaskPlan> tasks;

  const PlanAndTasksLoaded({required this.plans, required this.tasks});

  @override
  List<Object?> get props => [plans, tasks];
}
