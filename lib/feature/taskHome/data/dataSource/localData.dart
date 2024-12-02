import 'package:hive/hive.dart';

import '../../domain/entity/taskEntity.dart';


abstract class TaskLocalDataSource {
  Future<void> addTask(TaskEntity task);
  Future<List<TaskEntity>> getAllTasks();
  Future<void> deleteTask(String id);
  Future<void> updateTask(TaskEntity task);
}

class HiveTaskLocalDataSource implements TaskLocalDataSource {
  final Box<TaskEntity> taskBox;

  HiveTaskLocalDataSource(this.taskBox);

  @override
  Future<void> addTask(TaskEntity task) async {
    await taskBox.put(task.id, task);
  }

  @override
  Future<List<TaskEntity>> getAllTasks() async {
    return taskBox.values.toList();
  }

  @override
  Future<void> deleteTask(String id) async {
    await taskBox.delete(id);
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    await taskBox.put(task.id, task);
  }
}
