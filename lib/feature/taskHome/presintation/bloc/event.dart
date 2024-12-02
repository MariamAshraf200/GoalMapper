
import 'package:equatable/equatable.dart';

import '../../data/model/taskModel.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;

  AddTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final int taskId;

  DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;

  UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}
