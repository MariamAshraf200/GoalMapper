import '../../domain/entity/taskEntity.dart';
import '../../domain/repo_interface/repoTask.dart';
import '../dataSource/abstract_data_scource.dart';
import '../model/taskModel.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource dataSource;

  TaskRepositoryImpl(this.dataSource);

  @override
  Future<List<TaskDetails>> getTasks() async {
    try {
      final taskModels = await dataSource.getAllTasks();
      return taskModels.map((taskModel) => taskModel.toEntity()).toList();
    } catch (e) {
      throw Exception("Error loading tasks from local data source: $e");
    }
  }

  @override
  Future<List<TaskDetails>> getTasksByStatus(String status) async {
    try {
      final taskModels = await dataSource.getTasksByStatus(status);
      return taskModels.map((taskModel) => taskModel.toEntity()).toList();
    } catch (e) {
      throw Exception("Error loading tasks with status '$status': $e");
    }
  }

  @override
  Future<List<TaskDetails>> getTasksByPriority(String priority) async {
    try {
      final taskModels = await dataSource.getTasksByPriority(priority);
      return taskModels.map((taskModel) => taskModel.toEntity()).toList();
    } catch (e) {
      throw Exception("Error loading tasks with priority '$priority': $e");
    }
  }

  @override
  Future<List<TaskDetails>> getTasksByDate(String date) async {
    try {
      final taskModels = await dataSource.getTasksByDate(date);
      return taskModels.map((taskModel) => taskModel.toEntity()).toList();
    } catch (e) {
      throw Exception("Error loading tasks with date '$date': $e");
    }
  }

  @override
  Future<List<TaskDetails>> getTasksByPlanId(String planId) async {
    try {
      final taskModels = await dataSource.getTasksByPlanId(planId);
      return taskModels.map((taskModel) => taskModel.toEntity()).toList();
    } catch (e) {
      throw Exception("Error loading tasks by plan ID '$planId': $e");
    }
  }

  @override
  Future<List<TaskDetails>> filterTasks({
    required String date,
    String? priority,
    String? status,
  }) async {
    final taskModels = await dataSource.getTasksByDate(date);
    return taskModels
        .where((task) =>
    (priority == null || task.priority == priority) &&
        (status == null || task.status == status))
        .map((task) => task.toEntity())
        .toList();
  }

  @override
  Future<void> addTask(TaskDetails task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await dataSource.addTask(taskModel);
    } catch (e) {
      throw Exception("Error adding task to local data source: $e");
    }
  }

  @override
  Future<void> updateTask(TaskDetails task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await dataSource.updateTask(taskModel);
    } catch (e) {
      throw Exception("Error updating task in local data source: $e");
    }
  }

  @override
  Future<void> updateTaskStatus(String taskId, String newStatus, String updatedTime) async {
    try {
      // Fetch the task by ID
      final task = (await dataSource.getAllTasks()).firstWhere((task) => task.id == taskId);

      // Update the task with new status and updated time
      final updatedTask = task.copyWith(
        status: newStatus,
        time: updatedTime, // Pass the time as a field in your model
      );

      // Update the task in the data source
      await dataSource.updateTask(updatedTask);
    } catch (e) {
      throw Exception("Error updating task status: $e");
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await dataSource.deleteTask(taskId);
    } catch (e) {
      throw Exception("Error deleting task from local data source: $e");
    }
  }
}