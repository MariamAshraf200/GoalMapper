import 'package:equatable/equatable.dart';
import 'package:mapper_app/feature/taskHome/domain/entity/taskEntity.dart';

// Base class for TaskEvent
abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

// Event to get the list of tasks
class GetTasksEvent extends TaskEvent {}

// Event to add a new task
class AddTaskEvent extends TaskEvent {
  final TaskEntity task;

  const AddTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

// Event to update an existing task
class UpdateTaskEvent extends TaskEvent {
  final TaskEntity task;

  const UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

// Event to delete a task by its ID
class DeleteTaskEvent extends TaskEvent {
  final String taskId;

  const DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

// New event to indicate a successful task addition
class TaskAddedSuccessEvent extends TaskEvent {
  final TaskEntity task;

  const TaskAddedSuccessEvent(this.task);

  @override
  List<Object?> get props => [task];
}
