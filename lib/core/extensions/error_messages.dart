// Centralized error message helpers for tasks/repository operations

class ErrorStrings {
  static String loadingTasks(Object? e) => "Error loading tasks from local data source: $e";

  static String loadingTasksWithStatus(Object? status, Object? e) =>
      "Error loading tasks with status '$status': $e";

  static String loadingTasksWithPriority(Object? priority, [Object? e]) =>
      "Error loading tasks with priority '$priority'${e != null ? ': $e' : ''}";

  static String loadingTasksWithDate(Object? date, Object? e) =>
      "Error loading tasks with date '$date': $e";

  static String loadingTasksByPlanId(Object? planId, Object? e) =>
      "Error loading tasks by plan ID '$planId': $e";

  // Generic wrappers
  static String addTaskError(Object? e) => "Error adding task to local data source: $e";
  static String updateTaskError(Object? e) => "Error updating task in local data source: $e";
  static String updateTaskStatusError(Object? e) => "Error updating task status: $e";
  static String deleteTaskError(Object? e) => "Error deleting task from local data source: $e";
}

