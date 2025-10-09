import '../entity/taskEntity.dart';
import '../entity/task_enum.dart';

abstract class TaskRepository {
  Future<List<TaskDetails>> getTasks();
  Future<List<TaskDetails>> getTasksByStatus(TaskStatus? status);
  Future<List<TaskDetails>> getTasksByPriority(TaskPriority? priority);
  Future<void> addTask(TaskDetails task);
  Future<void> updateTask(TaskDetails task);
  Future<void> deleteTask(String taskId);
  Future<List<TaskDetails>> getTasksByDate(String date);
  Future<void> updateTaskStatus(String taskId, String newStatus);
  Future<List<TaskDetails>> filterTasks({
    required String date,
    String? priority,
    String? status,
  });
  Future<List<TaskDetails>> getTasksByPlanId(String planId); // Add this method
}
