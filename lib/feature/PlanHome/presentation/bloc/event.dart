import 'package:equatable/equatable.dart';

import '../../domain/entities/plan_entity.dart';

abstract class PlanEvent extends Equatable {
  const PlanEvent();

  @override
  List<Object?> get props => [];
}

class GetAllPlansEvent extends PlanEvent {}

class GetPlansByCategoryEvent extends PlanEvent {
  final String category;

  const GetPlansByCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class GetPlansByPriorityEvent extends PlanEvent {
  final String priority;

  const GetPlansByPriorityEvent(this.priority);

  @override
  List<Object?> get props => [priority];
}

class AddPlanEvent extends PlanEvent {
  final PlanDetails plan;

  const AddPlanEvent(this.plan);

  @override
  List<Object?> get props => [plan];
}

class UpdatePlanEvent extends PlanEvent {
  final PlanDetails plan;

  const UpdatePlanEvent(this.plan);

  @override
  List<Object?> get props => [plan];
}

class DeletePlanEvent extends PlanEvent {
  final String planId;

  const DeletePlanEvent(this.planId);

  @override
  List<Object?> get props => [planId];
}

class UpdatePlanStatusEvent extends PlanEvent {
  final String planId;
  final String newStatus;
  final String updatedTime;

  const UpdatePlanStatusEvent(this.planId, this.newStatus, {required this.updatedTime});

  @override
  List<Object?> get props => [planId, newStatus, updatedTime];
}

class GetPlansByDateEvent extends PlanEvent {
  final String date; // Assuming date is in String format

  const GetPlansByDateEvent(this.date);

  @override
  List<Object?> get props => [date];
}

class FilterPlansEvent extends PlanEvent {
  final String date; // Filter by date
  final String? priority; // Filter by priority (optional)
  final String? category; // Filter by category (optional)
  final String? status; // Filter by status (optional)

  const FilterPlansEvent({
    required this.date,
    this.priority,
    this.category,
    this.status,
  });

  @override
  List<Object?> get props => [date, priority, category, status];
}

class GetPlansByStatusEvent extends PlanEvent {
  final String status; // Status can be 'Completed', 'Not Completed', etc.

  const GetPlansByStatusEvent(this.status);

  @override
  List<Object?> get props => [status];
}
