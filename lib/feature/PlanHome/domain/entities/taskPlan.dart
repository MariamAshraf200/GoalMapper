

import 'package:equatable/equatable.dart';

enum TaskPlanStatus { toDo, done }

class TaskPlan extends Equatable {
  final String id;
  final String text;
  final TaskPlanStatus status;

  const TaskPlan({
    required this.id,
    required this.text,
    this.status = TaskPlanStatus.toDo,
  });

  TaskPlan copyWith({
    String? id,
    String? text,
    TaskPlanStatus? status,
  }) {
    return TaskPlan(
      id: id ?? this.id,
      text: text ?? this.text,
      status: status ?? this.status,
    );
  }

  factory TaskPlan.fromMap(Map<String, dynamic> map) {
    return TaskPlan(
      id: map['id'] as String,
      text: map['text'] as String,
      status: TaskPlanStatus.values.firstWhere(
            (e) => e.toString() == "TaskStatus." + (map['status'] ?? 'toDo'),
        orElse: () => TaskPlanStatus.toDo,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'status': status.name,
    };
  }

  @override
  List<Object?> get props => [id, text, status];
}