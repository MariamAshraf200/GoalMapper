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
  final String priority;

  @HiveField(6)
  final String status;

  // Constructor
  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.priority,
    required this.status,
  });

  TaskDetails toEntity() {
    return TaskDetails(
      id: id,
      title: title,
      description: description,
      date: date,
      time: time,
      priority: priority,
      status: status,
    );
  }

  factory TaskModel.fromEntity(TaskDetails entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      date: entity.date,
      time: entity.time,
      priority: entity.priority,
      status: entity.status,
    );
  }

}
