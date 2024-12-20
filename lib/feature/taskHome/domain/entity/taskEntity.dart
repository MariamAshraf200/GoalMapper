class TaskDetails {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String priority;
   String status;

  TaskDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.priority,
    required this.status,
  });

  TaskDetails copyWith({
    String? id,
    String? title,
    String? description,
    String? date,
    String? time,
    String? priority,
    String? status,
  }) {
    return TaskDetails(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      priority: priority ?? this.priority,
      status: status ?? this.status,
    );
  }
}
