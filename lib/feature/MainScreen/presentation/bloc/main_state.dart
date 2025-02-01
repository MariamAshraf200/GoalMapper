import 'package:equatable/equatable.dart';

import '../../../taskHome/data/model/taskModel.dart';
import '../../../taskHome/domain/entity/taskEntity.dart';

abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object?> get props => [];
}

class MainInitial extends MainState {}

class MainTaskLoading extends MainState {}


class MainTaskLoaded extends MainState {
  final List<TaskDetails> tasks;

  const MainTaskLoaded(this.tasks, );

  @override
  List<Object?> get props => [tasks, ];
}

class MainTaskError extends MainState {
  final String message;

  const MainTaskError(this.message);

  @override
  List<Object?> get props => [message];
}

class MainTaskActionSuccess extends MainState {
  final String message;

  const MainTaskActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}


class MainTaskAddSuccess extends MainState {
  final String message;
  final TaskModel task;
  const MainTaskAddSuccess(this.message, this.task);

  @override
  List<Object?> get props => [message,task];
}

