import 'package:equatable/equatable.dart';
import 'package:mapper_app/feature/taskHome/data/model/taskModel.dart';

import '../../../domain/entity/taskEntity.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;

  const TaskLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}

class TaskActionSuccess extends TaskState {
  final String message;

  const TaskActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}


class TaskAddSuccess extends TaskState {
  final String message;
final TaskModel task;

  TaskAddSuccess(this.message, this.task);


  @override
  List<Object?> get props => [message,task];
}

