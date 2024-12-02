import '../entity/taskEntity.dart';

abstract class TaskRepository {
  Future<void> addTask(TaskEntity task);
  Future<void> deleteTask(String id);
  Future<List<TaskEntity>> getAllTasks();
  Future<void> updateTask(TaskEntity task);
}
