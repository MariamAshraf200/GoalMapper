import '../model/taskModel.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getAllTasks();
  Future<List<TaskModel>> getTasksByStatus(String status);
  Future<List<TaskModel>> getTasksByPriority(String priority);
  Future<List<TaskModel>> getTasksByDate(String date);
  Future<List<TaskModel>> getTasksByPlanId(String planId); // Add this method
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
}