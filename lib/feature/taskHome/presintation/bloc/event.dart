import 'package:equatable/equatable.dart';

import '../../domain/entity/taskEntity.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class GetAllTasksEvent extends TaskEvent {}

class GetTasksByStatusEvent extends TaskEvent {
  final String status;

  const GetTasksByStatusEvent(this.status);
}

class AddTaskEvent extends TaskEvent {
  final TaskEntity task;

  const AddTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final TaskEntity task;

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
  final String newStatus;

  UpdateTaskStatusEvent(this.taskId, this.newStatus);
}

class GetTasksByDateEvent extends TaskEvent {
  final String date; // Assuming date is in String format

  const GetTasksByDateEvent(this.date);

  @override
  List<Object?> get props => [date];
}
