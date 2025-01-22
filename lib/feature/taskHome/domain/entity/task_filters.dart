import 'package:equatable/equatable.dart';

class TaskFilters extends Equatable {
  final String? date;
  final String? priority;
  final String? status;

  const TaskFilters({
     this.date,
    this.priority,
    this.status,
  });

  @override
  List<Object?> get props => [date, priority, status];
}
