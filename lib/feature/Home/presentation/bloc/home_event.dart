import 'package:equatable/equatable.dart';
import 'package:mapperapp/feature/taskHome/domain/entity/taskEntity.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {}

class HomeTasksUpdated extends HomeEvent {
  final List<TaskDetails> tasks;
  const HomeTasksUpdated(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

