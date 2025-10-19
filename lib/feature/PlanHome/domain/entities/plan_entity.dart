import '../../data/model/planModel.dart';
import 'package:equatable/equatable.dart';

import 'taskPlan.dart';


class PlanDetails extends Equatable {
  static const _noValue = Object();
  final String id;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String priority;
  final String category;
  final String status;
  final String? updatedTime;
  final List<String>? images;
  final bool completed;
  final List<TaskPlan> tasks;
  final double? progress;

  const PlanDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.priority,
    required this.category,
    required this.status,
    this.updatedTime,
    this.images,
    this.completed = false,
    this.tasks = const [],
    this.progress,
  });

  PlanDetails copyWith({
    String? id,
    String? title,
    String? description,
    String? startDate,
    String? endDate,
    String? priority,
    String? category,
    Object? status = _noValue,
    Object? updatedTime = _noValue,
    Object? images = _noValue,
    bool? completed,
    List<TaskPlan>? tasks,
    double? progress,
  }) {
    return PlanDetails(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      status: status != _noValue ? status as String : this.status,
      updatedTime: updatedTime != _noValue ? updatedTime as String? : this.updatedTime,
      images: images != _noValue ? images as List<String>? : this.images,
      completed: completed ?? this.completed,
      tasks: tasks ?? this.tasks,
      progress: progress ?? this.progress,
    );
  }

  PlanModel toModel() {
    return PlanModel(
      id: id,
      title: title,
      description: description,
      startDate: startDate,
      endDate: endDate,
      priority: priority,
      category: category,
      status: status,
      updatedTime: updatedTime,
      images: images,
      completed: completed,
      tasks: tasks,
    );
  }

  bool get isCompleted => status.toLowerCase() == 'completed' || completed;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    startDate,
    endDate,
    priority,
    category,
    status,
    updatedTime,
    images,
    completed,
    tasks,
    progress,
  ];
}
