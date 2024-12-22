
import '../entity/taskEntity.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> getTasks();
  Future<List<TaskEntity>> getTasksByStatus(String status);
  Future<void> addTask(TaskEntity task);
  Future<void> updateTask(TaskEntity task);
  Future<void> deleteTask(String taskId);
  Future<List<TaskEntity>> getTasksByDate(String date);

  Future<void> updateTaskStatus(String taskId, String newStatus);
}
