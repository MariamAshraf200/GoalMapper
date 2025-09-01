import 'package:equatable/equatable.dart';

import '../../data/model/taskModel.dart';

class TaskDetails extends Equatable {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String endTime;
  final String priority;
  final String category;
  final String status;
  final String? updatedTime;
  final String? planId;

  const TaskDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.endTime,
    required this.priority,
    required this.status,
    required this.category,
    this.updatedTime,
    this.planId,
  });

  static const _noValue = Object();

  TaskDetails copyWith({
    String? id,
    String? title,
    String? description,
    String? date,
    String? time,
    String? endTime,
    String? priority,
    Object? status = _noValue,
    String? category,
    Object? updatedTime = _noValue,
    Object? planId = _noValue,
  }) {
    return TaskDetails(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      endTime: endTime ?? this.endTime,
      priority: priority ?? this.priority,
      status: status != _noValue ? status as String : this.status,
      category: category ?? this.category,
      updatedTime: updatedTime != _noValue ? updatedTime as String? : this.updatedTime,
      planId: planId != _noValue ? planId as String? : this.planId,
    );
  }

  TaskModel toModel() {
    return TaskModel(
      category: category,
      title: title,
      description: description,
      date: date,
      time: time,
      endTime: endTime,
      priority: priority,
      id: id,
      status: status,
      updatedTime: updatedTime, 
      planId: planId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    date,
    time,
    endTime,
    priority,
    category,
    status,
    updatedTime,
    planId,
  ];
}
