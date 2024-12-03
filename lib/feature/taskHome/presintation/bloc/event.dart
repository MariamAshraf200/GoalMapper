import 'package:equatable/equatable.dart';
import 'package:mapper_app/feature/taskHome/domain/entity/taskEntity.dart';

// Base class for TaskEvent
abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class GetTasksEvent extends TaskEvent {
  final String? status;

  const GetTasksEvent({this.status});

  @override
  List<Object?> get props => [status];
}

class AddTaskEvent extends TaskEvent {
  final TaskEntity task;

  const AddTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final String taskId;
  final TaskEntity updatedTask;

  const UpdateTaskEvent(this.taskId, this.updatedTask);

  @override
  List<Object?> get props => [taskId, updatedTask];
}

// Event to delete a task by its ID
class DeleteTaskEvent extends TaskEvent {
  final String taskId;

  const DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

// Event to indicate a successful task addition
class TaskAddedSuccessEvent extends TaskEvent {
  final TaskEntity task;

  const TaskAddedSuccessEvent(this.task);

  @override
  List<Object?> get props => [task];
}

// Event to mark a task as completed
class MarkTaskAsDoneEvent extends TaskEvent {
  final String taskId;

  const MarkTaskAsDoneEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

// Event to change the status of a task
class ChangeTaskStatusEvent extends TaskEvent {
  final String taskId;
  final String newStatus;

  const ChangeTaskStatusEvent(this.taskId, this.newStatus);

  @override
  List<Object?> get props => [taskId, newStatus];
}

// Event to clear all tasks (e.g., for testing or resetting data)
class ClearAllTasksEvent extends TaskEvent {
  const ClearAllTasksEvent();
}
