// repo_interface/task_repo.dart

import '../../data/model/taskModel.dart';
import '../entity/taskEntity.dart';

abstract class TaskRepository {
  Future<List<TaskDetails>> getTasks();
  Future<List<TaskDetails>> getTasksByStatus(String status);
  Future<void> addTask(TaskDetails task);
  Future<void> updateTask(TaskDetails task);
  Future<void> deleteTask(String taskId);
  Future<List<TaskDetails>> getTasksByDate(String date);

  Future<void> updateTaskStatus(String taskId, String newStatus);
}
