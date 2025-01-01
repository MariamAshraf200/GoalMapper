class TaskEntity {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String endTime; // New field for end time
  final String priority;
  final String status;
  final String category; // New field for category

  TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.endTime, // Add endTime to the constructor
    required this.priority,
    required this.status,
    required this.category,
  });

  TaskEntity copyWith({
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
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      endTime: endTime ?? this.endTime, // Copy endTime
      priority: priority ?? this.priority,
      status: status ?? this.status,
      category: category ?? this.category,
    );
  }
}
