import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../feature/PlanHome/data/model/planModel.dart';
import '../feature/taskHome/data/model/categoryModel.dart';
import '../feature/taskHome/data/model/taskModel.dart';

class HiveService {
  static const String _taskBoxName = 'tasks';
  static const String _categoryBoxName = 'categories';
  static const String _planBoxName = 'plans'; // Add Plan Box name

  Future<void> initHive() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskModelAdapter());
    }

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CategoryModelAdapter());
    }

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(PlanModelAdapter());
    }

    await Hive.openBox<TaskModel>(_taskBoxName);
    await Hive.openBox<CategoryModel>(_categoryBoxName);
    await Hive.openBox<PlanModel>(_planBoxName); // Open Plan Box
  }

  Box<TaskModel> getTaskBox() => Hive.box<TaskModel>(_taskBoxName);
  Box<CategoryModel> getCategoryBox() => Hive.box<CategoryModel>(_categoryBoxName);
  Box<PlanModel> getPlanBox() => Hive.box<PlanModel>(_planBoxName); // Get Plan Box

  Future<void> closeHive() async {
    if (Hive.isBoxOpen(_taskBoxName)) {
      await Hive.box<TaskModel>(_taskBoxName).close();
    }
    if (Hive.isBoxOpen(_categoryBoxName)) {
      await Hive.box<CategoryModel>(_categoryBoxName).close();
    }
    if (Hive.isBoxOpen(_planBoxName)) {
      await Hive.box<PlanModel>(_planBoxName).close();
    }
    await Hive.close();
  }
}
