
import 'package:hive/hive.dart';

import '../../domain/entity/taskEntity.dart';
import '../../domain/repo_interface/repo.dart';
import '../model/taskModel.dart';

class TaskRepositoryImpl implements TaskRepository {
  final Box<TaskModel> taskBox;

  TaskRepositoryImpl(this.taskBox);

  @override
  Future<List<TaskEntity>> getTasks() async {
    try {
      final taskModels = taskBox.values.toList();
      return taskModels.map((taskModel) => taskModel.toEntity()).toList();
    } catch (e) {
      throw Exception("Error loading tasks from Hive: $e");
    }
  }

  @override
  Future<void> addTask(TaskEntity task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await taskBox.add(taskModel);
    } catch (e) {
      throw Exception("Error adding task to Hive: $e");
    }
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    try {
      final taskIndex = taskBox.values.toList().indexWhere((model) => model.id == task.id);
      if (taskIndex != -1) {
        await taskBox.putAt(taskIndex, TaskModel.fromEntity(task));
      } else {
        throw Exception("Task not found");
      }
    } catch (e) {
      throw Exception("Error updating task in Hive: $e");
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      final taskIndex = taskBox.values.toList().indexWhere((model) => model.id == taskId);
      if (taskIndex != -1) {
        await taskBox.deleteAt(taskIndex);
      } else {
        throw Exception("Task not found");
      }
    } catch (e) {
      throw Exception("Error deleting task from Hive: $e");
    }
  }
}
