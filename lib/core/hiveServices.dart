import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapper_app/feature/taskHome/data/model/taskModel.dart';
import 'package:mapper_app/feature/taskHome/data/model/categoryModel.dart'; // Import the category model

// class HiveService {
//   static const String _taskBoxName = 'tasks';
//   static const String _categoryBoxName = 'categories'; // Box name for categories
//
//   /// Initialize Hive and open the task and category boxes
//   Future<void> initHive() async {
//     // Register the adapters for TaskModel and CategoryModel
//     Hive.registerAdapter(TaskModelAdapter());
//     Hive.registerAdapter(CategoryModelAdapter());
//
//     // Open the boxes
//     await Hive.openBox<TaskModel>(_taskBoxName);
//     await Hive.openBox<CategoryModel>(_categoryBoxName);
//   }
//
//   /// Add a new task to Hive
//   Future<void> addTask(TaskModel task) async {
//     final taskBox = Hive.box<TaskModel>(_taskBoxName);
//     await taskBox.add(task);
//   }
//
//
//
//   /// Retrieve all tasks from Hive
//   List<TaskModel> getTasks() {
//     final taskBox = Hive.box<TaskModel>(_taskBoxName);
//     return taskBox.values.toList();
//   }
//
//   /// Retrieve tasks based on a specific date
//   List<TaskModel> getTasksByDate(String date) {
//     final taskBox = Hive.box<TaskModel>(_taskBoxName);
//     return taskBox.values
//         .where((task) => task.date == date)
//         .toList();
//   }
//
//   /// Delete a task by index
//   Future<void> deleteTask(int index) async {
//     final taskBox = Hive.box<TaskModel>(_taskBoxName);
//     if (index < taskBox.length) {
//       await taskBox.deleteAt(index);
//     }
//   }
//
//   /// Update a task at a specific index
//   Future<void> updateTask(int index, TaskModel updatedTask) async {
//     final taskBox = Hive.box<TaskModel>(_taskBoxName);
//     if (index < taskBox.length) {
//       await taskBox.putAt(index, updatedTask);
//     }
//   }
//
//   /// Add a new category to Hive
//   Future<void> addCategory(String categoryName, String id) async {
//     final categoryBox = Hive.box<CategoryModel>(_categoryBoxName);
//     final category = CategoryModel(categoryName: categoryName, id: id);
//     await categoryBox.add(category);
//   }
//
//   /// Retrieve all categories from Hive
//   List<CategoryModel> getCategories() {
//     final categoryBox = Hive.box<CategoryModel>(_categoryBoxName);
//     return categoryBox.values.toList();
//   }
//
//   /// Delete a category by index
//   Future<void> deleteCategory(int index) async {
//     final categoryBox = Hive.box<CategoryModel>(_categoryBoxName);
//     if (index < categoryBox.length) {
//       await categoryBox.deleteAt(index);
//     }
//   }
//
//   /// Close the Hive boxes (optional, during app exit)
//   Future<void> closeHive() async {
//     await Hive.close();
//   }
// }
class HiveService {
  static const String _taskBoxName = 'tasks';
  static const String _categoryBoxName = 'categories';

  Future<void> initHive() async {
    Hive.registerAdapter(TaskModelAdapter());
    Hive.registerAdapter(CategoryModelAdapter());
    await Hive.openBox<TaskModel>(_taskBoxName);
    await Hive.openBox<CategoryModel>(_categoryBoxName);
  }

  Future<void> addTask(TaskModel task) async {
    try {
      final taskBox = Hive.box<TaskModel>(_taskBoxName);
      await taskBox.add(task);
    } catch (e) {
      if (kDebugMode) {
        print('Error adding task: $e');
      }
      rethrow;
    }
  }

  Future<List<TaskModel>> getTasks() async {
    try {
      final taskBox = Hive.box<TaskModel>(_taskBoxName);
      return taskBox.values.toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error retrieving tasks: $e');
      }
      return [];
    }
  }

  // List<TaskModel> getTasksByDate(String date) {
  //   final taskBox = Hive.box<TaskModel>(_taskBoxName);
  //   return taskBox.values.where((task) {
  //     final taskDate = DateTime.tryParse(task.date ?? '');
  //     final selectedDate = DateTime.tryParse(date);
  //     return taskDate != null && selectedDate != null && isSameDay(taskDate, selectedDate);
  //   }).toList();
  // }
  List<TaskModel> getTasksByDate(String date) {
    final taskBox = Hive.box<TaskModel>(_taskBoxName);
    if (kDebugMode) {
      print('All tasks in Hive: ${taskBox.values.toList()}');
    } // Debugging: Print all tasks

    return taskBox.values.where((task) {
      if (kDebugMode) {
        print('Task Date: ${task.date}, Filter Date: $date');
      } // Debugging: Inspect task and filter dates
      return task.date == date; // Ensure this matches the stored format
    }).toList();
  }


  Future<void> updateTask(TaskModel updatedTask) async {
    final taskBox = Hive.box<TaskModel>(_taskBoxName);
    final key = taskBox.keys.firstWhere(
          (key) => taskBox.get(key)?.id == updatedTask.id,
      orElse: () => null,
    );
    if (key != null) {
      await taskBox.put(key, updatedTask);
    } else {
      throw Exception('Task with id ${updatedTask.id} not found.');
    }
  }



  Future<void> deleteTask(String id) async {
    final taskBox = Hive.box<TaskModel>(_taskBoxName);
    final key = taskBox.keys.firstWhere(
          (key) => taskBox.get(key)?.id == id,
      orElse: () => null,
    );
    if (key != null) {
      await taskBox.delete(key);
    } else {
      throw Exception('Task with id $id not found.');
    }
  }

  Future<void> addCategory(String categoryName, String id) async {
    final categoryBox = Hive.box<CategoryModel>(_categoryBoxName);
    if (categoryBox.values.any((category) => category.categoryName == categoryName)) {
      throw Exception('Category with name $categoryName already exists.');
    }
    final category = CategoryModel(categoryName: categoryName, id: id);
    await categoryBox.add(category);
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final categoryBox = Hive.box<CategoryModel>(_categoryBoxName);
      return categoryBox.values.toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error retrieving categories: $e');
      }
      return [];
    }
  }

  Future<void> closeHive() async {
    if (Hive.isBoxOpen(_taskBoxName)) {
      await Hive.box<TaskModel>(_taskBoxName).close();
    }
    if (Hive.isBoxOpen(_categoryBoxName)) {
      await Hive.box<CategoryModel>(_categoryBoxName).close();
    }
    await Hive.close();
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}
