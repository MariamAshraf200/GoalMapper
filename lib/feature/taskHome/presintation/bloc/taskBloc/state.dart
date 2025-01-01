import 'package:equatable/equatable.dart';

import '../../../data/model/taskModel.dart';
import '../../../domain/entity/taskEntity.dart';
import '../../../domain/entity/task_filters.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

// class TaskLoaded extends TaskState {
//   final List<TaskDetails> tasks;
//   const TaskLoaded(this.tasks);
//   @override
//   List<Object?> get props => [tasks];
// }

class TaskLoaded extends TaskState {
  final List<TaskDetails> tasks;
  final TaskFilters filters; // Include current filters

  const TaskLoaded(this.tasks, {required this.filters});

  @override
  List<Object?> get props => [tasks, filters];
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
  const TaskAddSuccess(this.message, this.task);

  @override
  List<Object?> get props => [message,task];
}

