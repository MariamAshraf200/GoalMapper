import 'package:hive/hive.dart';
import '../../domain/entities/plan_entity.dart';

part 'planModel.g.dart';

@HiveType(typeId: 3)
class PlanModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String startDate;

  @HiveField(4)
  final String endDate;

  @HiveField(5)
  final String category;

  @HiveField(6)
  final String priority;

  @HiveField(7)
  final String? updatedTime; // Optional field to track last update time

  @HiveField(8)
  final String status; // New field to track the status of the plan

  @HiveField(9)
  final String? image; // New field to store image URL or path

  @HiveField(10)
  final bool completed; // New field to track if the plan is completed

  // Constructor
  const PlanModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.category,
    required this.priority,
    this.updatedTime, // Optional for backward compatibility
    required this.status, // New status field
    this.image, // Optional image field
    this.completed = false, // Defaults to false for backward compatibility
  });

  /// Converts the `PlanModel` to a `PlanDetails` entity.
  PlanDetails toEntity() {
    return PlanDetails(
      id: id,
      title: title,
      description: description,
      startDate: startDate,
      endDate: endDate,
      category: category,
      priority: priority,
      updatedTime: updatedTime, // Mapping updatedTime to the entity
      status: status, // Mapping status to the entity
      image: image, // Mapping image to the entity
      completed: completed, // Mapping completed to the entity
    );
  }

  /// Creates a `PlanModel` from a `PlanDetails` entity.
  factory PlanModel.fromEntity(PlanDetails entity) {
    return PlanModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      startDate: entity.startDate,
      endDate: entity.endDate,
      category: entity.category,
      priority: entity.priority,
      updatedTime: entity.updatedTime, // Mapping updatedTime from the entity
      status: entity.status, // Mapping status from the entity
      image: entity.image, // Mapping image from the entity
      completed: entity.completed, // Mapping completed from the entity
    );
  }

  /// `copyWith` method for updating selected fields.
  PlanModel copyWith({
    String? id,
    String? title,
    String? description,
    String? startDate,
    String? endDate,
    String? category,
    String? priority,
    String? updatedTime,
    String? status, // Added status to the copyWith method
    String? image, // Optional image
    bool? completed, // Added completed to the copyWith method
  }) {
    return PlanModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      updatedTime: updatedTime ?? this.updatedTime, // Copying updatedTime
      status: status ?? this.status, // Copying status
      image: image ?? this.image, // Copying image
      completed: completed ?? this.completed, // Copying completed
    );
  }

  @override
  String toString() {
    return 'PlanModel(id: $id, title: $title, description: $description, startDate: $startDate, endDate: $endDate, category: $category, priority: $priority, updatedTime: $updatedTime, status: $status, image: $image, completed: $completed)';
  }
}
