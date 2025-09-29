import 'package:equatable/equatable.dart';


abstract class MainTaskEvent extends Equatable {
  const MainTaskEvent();

  @override
  List<Object?> get props => [];
}

class GetMainTasksEvent extends MainTaskEvent {}