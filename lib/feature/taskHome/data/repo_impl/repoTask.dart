import 'package:hive/hive.dart';
import '../../domain/entity/taskEntity.dart';
import '../../domain/repo_interface/repoTask.dart';
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
  Future<List<TaskEntity>> getTasksByStatus(String status) async {
    try {
      final taskModels = taskBox.values
          .where((taskModel) => taskModel.status == status)
          .toList();
      return taskModels.map((taskModel) => taskModel.toEntity()).toList();
    } catch (e) {
      throw Exception(
          "Error loading tasks with status '$status' from Hive: $e");
    }
  }

  @override
  Future<List<TaskEntity>> getTasksByDate(String date) async {
    try {
      final taskModels = taskBox.values
          .where((taskModel) => taskModel.date == date)
          .toList();
      return taskModels.map((taskModel) => taskModel.toEntity()).toList();
    } catch (e) {
      throw Exception("Error loading tasks with date '$date' from Hive: $e");
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
      final taskIndex =
      taskBox.values.toList().indexWhere((model) => model.id == task.id);
      if (taskIndex != -1) {
        await taskBox.putAt(taskIndex, TaskModel.fromEntity(task));
      } else {
        throw Exception("Task not found");
      }
    } catch (e) {
      throw Exception("Error updating task in Hive: $e");
    }
  }

  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    try {
      final taskIndex =
      taskBox.values.toList().indexWhere((model) => model.id == taskId);

      if (taskIndex != -1) {
        final existingTask = taskBox.getAt(taskIndex);

        if (existingTask != null) {
          final updatedTask = TaskModel(
            category: existingTask.category,
            id: existingTask.id,
            title: existingTask.title,
            description:
            existingTask.description,
            date: existingTask.date,
            time: existingTask.time,
            priority: existingTask.priority,
            status: newStatus,
          );

          // Replace the old task in the Hive box with the updated one
          await taskBox.putAt(taskIndex, updatedTask);
        }
      } else {
        throw Exception("Task not found");
      }
    } catch (e) {
      throw Exception("Error updating task status in Hive: $e");
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      final taskIndex =
      taskBox.values.toList().indexWhere((model) => model.id == taskId);
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
