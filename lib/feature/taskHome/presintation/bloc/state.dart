import '../../domain/entity/taskEntity.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;

  TaskLoaded({required this.tasks});
}

class TaskAddedSuccess extends TaskState {
  final String message;
  final TaskEntity? addedTask;

  TaskAddedSuccess({required this.message, this.addedTask});
}

// State when a specific task is successfully updated
class TaskUpdatedSuccess extends TaskState {
  final String message;
  final TaskEntity updatedTask;

  TaskUpdatedSuccess({required this.message, required this.updatedTask});
}

class TaskDeletedSuccess extends TaskState {
  final String message;
  final String deletedTaskId;

  TaskDeletedSuccess({required this.message, required this.deletedTaskId});
}

class TasksClearedSuccess extends TaskState {
  final String message;

  TasksClearedSuccess({required this.message});
}

class TaskStatusChangedSuccess extends TaskState {
  final String message;
  final TaskEntity updatedTask;

  TaskStatusChangedSuccess({required this.message, required this.updatedTask});
}

class TaskError extends TaskState {
  final String message;

  TaskError({required this.message});
}
