import '../../domain/entity/taskEntity.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;

  TaskLoaded({required this.tasks});
}

class TaskError extends TaskState {
  final String message;

  TaskError({required this.message});
}

class TaskAddedSuccess extends TaskState {
  final String message;

  TaskAddedSuccess({required this.message});
}
