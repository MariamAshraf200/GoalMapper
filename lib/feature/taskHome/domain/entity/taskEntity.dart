import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../data/model/taskModel.dart';
import 'task_enum.dart';

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
    required this.category,
    required this.status,
    this.updatedTime,
    this.planId,
  });

  /// Default empty task
  factory TaskDetails.empty() {
    return TaskDetails(
      id: '',
      title: '',
      description: '',
      date: '',
      time: '',
      endTime: '',
      priority: TaskPriority.medium.toTaskPriorityString(),
      category: 'General',
      status: TaskStatus.toDo.toTaskStatusString(),
      updatedTime: null,
      planId: null,
    );
  }

  factory TaskDetails.fromFormData({
    required String title,
    required String description,
    required DateTime? date,
    required TimeOfDay? startTime,
    required TimeOfDay? endTime,
    required TaskPriority priority,
    required String? category,
    required String? planId,
    TaskDetails? existingTask,
    BuildContext? context,
  }) {
    final formattedDate =
    date != null ? DateFormat('dd/MM/yyyy').format(date) : '';

    final formattedStart = _formatTime(startTime, context) ?? '';
    final formattedEnd = _formatTime(endTime, context) ?? '';

    return (existingTask ?? TaskDetails.empty()).copyWith(
      id: existingTask?.id ?? const Uuid().v4(),
      title: title.trim(),
      description: description.trim(),
      date: formattedDate,
      time: formattedStart,
      endTime: formattedEnd,
      priority: priority.toTaskPriorityString(),
      category: category ?? 'General',
      status: existingTask?.status ?? TaskStatus.toDo.toTaskStatusString(),
      planId: planId,
    );
  }

  /// Pure `copyWith`
  TaskDetails copyWith({
    String? id,
    String? title,
    String? description,
    String? date,
    String? time,
    String? endTime,
    String? priority,
    String? category,
    String? status,
    String? updatedTime,
    String? planId,
  }) {
    return TaskDetails(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      endTime: endTime ?? this.endTime,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      status: status ?? this.status,
      updatedTime: updatedTime ?? this.updatedTime,
      planId: planId ?? this.planId,
    );
  }

  /// Convert entity to model
  TaskModel toModel() => TaskModel(
    id: id,
    title: title,
    description: description,
    date: date,
    time: time,
    endTime: endTime,
    priority: priority,
    category: category,
    status: status,
    updatedTime: updatedTime,
    planId: planId,
  );

  /// Helper to format time
  static String? _formatTime(TimeOfDay? timeOfDay, BuildContext? context) {
    if (timeOfDay == null) return null;
    if (context != null) return timeOfDay.format(context);

    final hour = timeOfDay.hourOfPeriod == 0 ? 12 : timeOfDay.hourOfPeriod;
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
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
