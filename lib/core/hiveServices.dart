import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


import '../feature/taskHome/data/model/categoryModel.dart';
import '../feature/taskHome/data/model/taskModel.dart';

class HiveService {
  static const String _taskBoxName = 'tasks';
  static const String _categoryBoxName = 'categories';

  Future<void> initHive() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskModelAdapter());
    }

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CategoryModelAdapter());
    }

    await Hive.openBox<TaskModel>(_taskBoxName);
    await Hive.openBox<CategoryModel>(_categoryBoxName);
  }

  Box<TaskModel> getTaskBox() => Hive.box<TaskModel>(_taskBoxName);

  Box<CategoryModel> getCategoryBox() => Hive.box<CategoryModel>(_categoryBoxName);

  Future<void> closeHive() async {
    if (Hive.isBoxOpen(_taskBoxName)) {
      await Hive.box<TaskModel>(_taskBoxName).close();
    }
    if (Hive.isBoxOpen(_categoryBoxName)) {
      await Hive.box<CategoryModel>(_categoryBoxName).close();
    }
    await Hive.close();
  }
}

