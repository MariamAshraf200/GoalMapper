import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../feature/taskHome/data/model/categoryModel.dart';
import '../feature/taskHome/data/model/taskModel.dart';

class HiveService {
  static const String _taskBoxName = 'tasks';
  static const String _categoryBoxName = 'categories'; // Box name for categories

  /// Initialize Hive and open the task and category boxes
  Future<void> initHive() async {
    // Register the adapters for TaskModel and CategoryModel
    Hive.registerAdapter(TaskModelAdapter());
    Hive.registerAdapter(CategoryModelAdapter());

    // Open the boxes
    await Hive.openBox<TaskModel>(_taskBoxName);
    await Hive.openBox<CategoryModel>(_categoryBoxName);
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

  /// Add a new category to Hive
  Future<void> addCategory(String categoryName, String id) async {
    final categoryBox = Hive.box<CategoryModel>(_categoryBoxName);
    final category = CategoryModel(categoryName: categoryName, id: id);
    await categoryBox.add(category);
  }

  /// Retrieve all categories from Hive
  List<CategoryModel> getCategories() {
    final categoryBox = Hive.box<CategoryModel>(_categoryBoxName);
    return categoryBox.values.toList();
  }

  /// Delete a category by index
  Future<void> deleteCategory(int index) async {
    final categoryBox = Hive.box<CategoryModel>(_categoryBoxName);
    if (index < categoryBox.length) {
      await categoryBox.deleteAt(index);
    }
  }

  /// Close the Hive boxes (optional, during app exit)
  Future<void> closeHive() async {
    await Hive.close();
  }
}
