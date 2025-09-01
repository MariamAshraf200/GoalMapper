import '../../domain/entity/task_enum.dart';
import '../model/taskModel.dart';
import '../model/categoryModel.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getAllTasks();
  Future<List<TaskModel>> getTasksByStatus(TaskStatus? status);
  Future<List<TaskModel>> getTasksByPriority(TaskPriority? priority);
  Future<List<TaskModel>> getTasksByDate(String date);
  Future<List<TaskModel>> getTasksByPlanId(String planId);
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
}

abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>> getAllCategories();
  Future<void> addCategory(CategoryModel category);
  Future<void> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String id);
}
