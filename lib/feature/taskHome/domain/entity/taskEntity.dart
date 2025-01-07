
import '../../data/model/taskModel.dart';

class TaskDetails {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String priority;
  final String category;
  String status;

  TaskDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.priority,
    required this.status,
    required this.category,
  });

  TaskDetails copyWith({
    String? id,
    String? title,
    String? description,
    String? date,
    String? time,
    String? priority,
    String? status,
    String? category,
  }) {
    return TaskDetails(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      category: category ?? this.category,
    );
  }

  @override
  String toString() {
    return 'TaskDetails(id: $id, title: $title, description: $description, date: $date, time: $time, priority: $priority, status: $status, category: $category)';
  }
}
