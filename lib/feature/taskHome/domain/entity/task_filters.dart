import 'package:equatable/equatable.dart';
import 'task_enum.dart';

class TaskFilters extends Equatable {
  static const _noValue = Object();

  final String? date;
  final TaskPriority? priority;
  final TaskStatus? status;

  const TaskFilters({
    this.date,
    this.priority,
    this.status,
  });

  TaskFilters copyWith({
    Object? date = _noValue,
    Object? priority = _noValue,
    Object? status = _noValue,
  }) {
    return TaskFilters(
      date: date != _noValue ? date as String? : this.date,
      priority: priority != _noValue ? priority as TaskPriority? : this.priority,
      status: status != _noValue ? status as TaskStatus? : this.status,
    );
  }

  String get toQueryString {
    final queryParameters = <String>[];

    if (date != null && date!.isNotEmpty) {
      queryParameters.add('date=$date');
    }
    if (priority != null) {
      queryParameters.add('priority=${priority!.toTaskPriorityString()}');
    }
    if (status != null) {
      queryParameters.add('status=${status!.toTaskStatusString()}');
    }

    return queryParameters.join('&');
  }

  bool get hasNoDataToFilter =>
      (date == null || date!.isEmpty) &&
      priority == null &&
      status == null;

  bool get hasDataToFilter => !hasNoDataToFilter;

  factory TaskFilters.withNoFilter() {
    return const TaskFilters();
  }

  @override
  List<Object?> get props => [
        date,
        priority,
        status,
      ];
}
