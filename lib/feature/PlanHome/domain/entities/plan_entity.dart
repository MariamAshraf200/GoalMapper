import '../../../taskHome/domain/entity/taskEntity.dart';
import '../../data/model/planModel.dart';


class PlanDetails {
  final String id;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String priority;
  final String category;
  late final String status; // Status field
  String? updatedTime;
  String? image;
  final bool completed; // Field to track if the plan is completed
  final List<TaskDetails> tasks; // Updated to use TaskDetails

  PlanDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.priority,
    required this.category,
    required this.status,
    this.updatedTime, // Optional
    this.image, // Optional
    this.completed = false, // Default to false for backward compatibility
    this.tasks = const [], // Default to an empty list
  });

  PlanDetails copyWith({
    String? id,
    String? title,
    String? description,
    String? startDate,
    String? endDate,
    String? priority,
    String? category,
    String? status,
    String? updatedTime,
    String? image,
    bool? completed,
    List<TaskDetails>? tasks, // Update tasks list
  }) {
    return PlanDetails(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      status: status ?? this.status,
      updatedTime: updatedTime ?? this.updatedTime,
      image: image ?? this.image,
      completed: completed ?? this.completed,
      tasks: tasks ?? this.tasks,
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
      image: image,
      completed: completed,
      tasks: tasks.map((task) => task.toModel()).toList(), // Convert TaskDetails to TaskModel
    );
  }

  @override
  String toString() {
    return 'PlanDetails(id: $id, title: $title, description: $description, startDate: $startDate, endDate: $endDate, priority: $priority, category: $category, status: $status, updatedTime: $updatedTime, image: $image, completed: $completed, tasks: $tasks)';
  }
}
