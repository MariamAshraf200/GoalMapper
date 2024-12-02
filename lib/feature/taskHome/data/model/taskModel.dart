import 'package:hive/hive.dart';

import '../../domain/entity/taskEntity.dart';

part 'taskModel.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String date;

  @HiveField(4)
  final String time;

  @HiveField(5)
  final String priority;

  // Constructor
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.priority,
  });

  // Convert Hive Model to Entity (if using Clean Architecture)
  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      date: date,
      time: time,
      priority: priority,
    );
  }

  factory Task.fromEntity(TaskEntity entity) {
    return Task(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      date: entity.date,
      time: entity.time,
      priority: entity.priority,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'priority': priority,
    };
  }

  // Factory Constructor to Create Task from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      priority: json['priority'] as String,
    );
  }
}
