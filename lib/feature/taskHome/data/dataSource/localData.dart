import 'package:hive/hive.dart';
import '../model/taskModel.dart';

abstract class TaskLocalDataSource {
  Future<void> addTask(TaskModel task);
  Future<List<TaskModel>> getAllTasks();
  Future<void> deleteTask(String id);
  Future<void> updateTask(TaskModel task);

}

class HiveTaskLocalDataSource implements TaskLocalDataSource {
  final Box<TaskModel> taskBox;

  HiveTaskLocalDataSource(this.taskBox);

  @override
  Future<void> addTask(TaskModel task) async {
    await taskBox.put(task.id, task);
  }

  @override
  Future<List<TaskModel>> getAllTasks() async {
    return taskBox.values.toList();
  }

  @override
  Future<void> deleteTask(String id) async {
    await taskBox.delete(id);
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await taskBox.put(task.id, task);
  }

  Future<List<TaskModel>> getTasksByStatus(String status) async {
    return taskBox.values.where((task) => task.status == status).toList();
  }

}
