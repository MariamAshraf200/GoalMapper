
import 'package:hive/hive.dart';
import '../../../../core/hiveServices.dart';
import '../model/taskModel.dart';
import 'abstract_data_scource.dart';
class HiveTaskLocalDataSource implements TaskLocalDataSource {
  final HiveService hiveService;

  HiveTaskLocalDataSource(this.hiveService);

  Box<TaskModel> get taskBox => hiveService.getTaskBox();

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

  @override
  Future<List<TaskModel>> getTasksByStatus(String status) async {
    return taskBox.values.where((task) => task.status == status).toList();
  }

  @override
  Future<List<TaskModel>> getTasksByDate(String date) async {
    return taskBox.values.where((task) => task.date == date).toList();
  }

  @override
  Future<List<TaskModel>> getTasksByPriority(String priority) async {
    return taskBox.values.where((task) => task.priority == priority).toList();
  }
}

