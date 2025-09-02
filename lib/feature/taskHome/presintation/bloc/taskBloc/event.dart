import 'package:equatable/equatable.dart';

import '../../../domain/entity/taskEntity.dart';
import '../../../domain/entity/task_enum.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class GetAllTasksEvent extends TaskEvent {}

class GetTasksByStatusEvent extends TaskEvent {
  final TaskStatus? status;

  const GetTasksByStatusEvent(this.status);

  @override
  List<Object?> get props => [status];
}

class GetTasksByPriorityEvent extends TaskEvent {
  final TaskPriority? priority;

  const GetTasksByPriorityEvent(this.priority);

  @override
  List<Object?> get props => [priority];
}

class AddTaskEvent extends TaskEvent {
  final TaskDetails task;
  final String? planId;

  const AddTaskEvent(this.task, {this.planId});

  @override
  List<Object?> get props => [task, planId];
}


class UpdateTaskEvent extends TaskEvent {
  final TaskDetails task;

  const UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;

  const DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class UpdateTaskStatusEvent extends TaskEvent {
  final String taskId;
  final TaskStatus? newStatus;
  final String updatedTime;

  const UpdateTaskStatusEvent(this.taskId, this.newStatus, {required this.updatedTime});

  @override
  List<Object?> get props => [taskId, newStatus, updatedTime];
}

class GetTasksByDateEvent extends TaskEvent {
  final String date; // Assuming date is in String format

  const GetTasksByDateEvent(this.date);

  @override
  List<Object?> get props => [date];
}

class FilterTasksEvent extends TaskEvent {
  final String date; // Filter by date
  final TaskPriority? priority; // Filter by priority (optional)
  final TaskStatus? status; // Filter by status (optional)

  const FilterTasksEvent({required this.date, this.priority, this.status});

  @override
  List<Object?> get props => [date, priority, status];
}

// New event to fetch tasks by planId
class GetTasksByPlanIdEvent extends TaskEvent {
  final String planId; // Plan ID to filter tasks

  const GetTasksByPlanIdEvent(this.planId);

  @override
  List<Object?> get props => [planId];
}