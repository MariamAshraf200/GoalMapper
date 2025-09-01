enum TaskFilterType { date, priority, status }
enum TaskPriority { low, medium, high }
enum TaskStatus { pending, inProgress, completed }

extension TaskFilterTypeExtension on TaskFilterType {
  static TaskFilterType fromString(String? type) {
    switch (type?.toUpperCase()) {
      case 'DATE':
        return TaskFilterType.date;
      case 'PRIORITY':
        return TaskFilterType.priority;
      case 'STATUS':
        return TaskFilterType.status;
      default:
        throw ArgumentError('Invalid TaskFilterType: $type');
    }
  }

  String toTaskFilterTypeString() {
    switch (this) {
      case TaskFilterType.date:
        return 'DATE';
      case TaskFilterType.priority:
        return 'PRIORITY';
      case TaskFilterType.status:
        return 'STATUS';
    }
  }
}

extension TaskPriorityExtension on TaskPriority {
  static TaskPriority fromString(String? priority) {
    switch (priority?.toUpperCase()) {
      case 'LOW':
        return TaskPriority.low;
      case 'MEDIUM':
        return TaskPriority.medium;
      case 'HIGH':
        return TaskPriority.high;
      default:
        throw ArgumentError('Invalid TaskPriority: $priority');
    }
  }

  String toTaskPriorityString() {
    switch (this) {
      case TaskPriority.low:
        return 'LOW';
      case TaskPriority.medium:
        return 'MEDIUM';
      case TaskPriority.high:
        return 'HIGH';
    }
  }
}

extension TaskStatusExtension on TaskStatus {
  static TaskStatus fromString(String? status) {
    switch (status?.toUpperCase()) {
      case 'PENDING':
        return TaskStatus.pending;
      case 'IN_PROGRESS':
        return TaskStatus.inProgress;
      case 'COMPLETED':
        return TaskStatus.completed;
      default:
        throw ArgumentError('Invalid TaskStatus: $status');
    }
  }

  String toTaskStatusString() {
    switch (this) {
      case TaskStatus.pending:
        return 'PENDING';
      case TaskStatus.inProgress:
        return 'IN_PROGRESS';
      case TaskStatus.completed:
        return 'COMPLETED';
    }
  }
}
