import 'package:hive/hive.dart';
import '../../domain/entity/taskEntity.dart';

part 'taskModel.g.dart';

@HiveType(typeId: 0)
class TaskModel {
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
  final String endTime;

  @HiveField(6)
  final String priority;

  @HiveField(7)
  final String status;

  @HiveField(8)
  final String category;

  // Constructor
  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.endTime,
    required this.priority,
    required this.status,
    required this.category,
  });

  TaskDetails toEntity() {
    return TaskDetails(
      id: id,
      title: title,
      description: description,
      date: date,
      time: time,
      endTime: endTime,
      priority: priority,
      status: status,
      category: category,
    );
  }

  factory TaskModel.fromEntity(TaskDetails entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      date: entity.date,
      time: entity.time,
      endTime: entity.endTime,
      priority: entity.priority,
      status: entity.status,
      category: entity.category,
    );
  }

  /// `copyWith` method for updating selected fields.
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? date,
    String? time,
    String? endTime,
    String? priority,
    String? status,
    String? category,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      endTime: endTime?? this.endTime,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      category: category ?? this.category,
    );
  }

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, description: $description, date: $date, time: $time, endTime: $endTime,priority: $priority, status: $status, category: $category)';
  }
}

