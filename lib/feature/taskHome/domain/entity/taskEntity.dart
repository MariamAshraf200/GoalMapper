class TaskEntity {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String priority;
  final String status;
  final String category; // New field for category

  TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.priority,
    required this.status,
    required this.category, // Add category to the constructor
  });

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? date,
    String? time,
    String? priority,
    String? status,
    String? category, // Add category to copyWith method
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      category: category ?? this.category, // Update category
    );
  }
}
