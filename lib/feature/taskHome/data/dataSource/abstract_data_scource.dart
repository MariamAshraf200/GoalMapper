
import '../model/taskModel.dart';

abstract class TaskLocalDataSource {
  Future<void> addTask(TaskModel task);
  Future<List<TaskModel>> getAllTasks();
  Future<void> deleteTask(String id);
  Future<void> updateTask(TaskModel task);
  Future<List<TaskModel>> getTasksByStatus(String status);
  Future<List<TaskModel>> getTasksByDate(String date);
  Future<List<TaskModel>> getTasksByPriority(String priority);
}