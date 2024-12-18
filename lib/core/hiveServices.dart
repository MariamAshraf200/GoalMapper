import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapper_app/feature/taskHome/domain/entity/taskEntity.dart';
import '../feature/taskHome/data/model/taskModel.dart';

class HiveService {
  static const String _taskBoxName = 'tasks';

  /// Initialize Hive and open the tasks box
  Future<void> initHive() async {
    // Register the adapter for TaskModel
    Hive.registerAdapter(TaskModelAdapter());

    // Open the box for tasks
    await Hive.openBox<TaskModel>(_taskBoxName);
  }

  /// Add a new task to Hive
  Future<void> addTask(TaskModel task) async {
    final taskBox = Hive.box<TaskModel>(_taskBoxName);
    await taskBox.add(task);
  }

  /// Retrieve all tasks from Hive
  List<TaskModel> getTasks() {
    final taskBox = Hive.box<TaskModel>(_taskBoxName);
    return taskBox.values.toList();
  }

  /// Retrieve tasks based on a specific date
  List<TaskModel> getTasksByDate(String date) {
    final taskBox = Hive.box<TaskModel>(_taskBoxName);
    return taskBox.values
        .where((task) => task.date == date)
        .toList();
  }

  /// Delete a task by index
  Future<void> deleteTask(int index) async {
    final taskBox = Hive.box<TaskModel>(_taskBoxName);
    if (index < taskBox.length) {
      await taskBox.deleteAt(index);
    }
  }

  /// Update a task at a specific index
  Future<void> updateTask(int index, TaskModel updatedTask) async {
    final taskBox = Hive.box<TaskModel>(_taskBoxName);
    if (index < taskBox.length) {
      await taskBox.putAt(index, updatedTask);
    }
  }

  /// Close the Hive boxes (optional, during app exit)
  Future<void> closeHive() async {
    await Hive.close();
  }
}
