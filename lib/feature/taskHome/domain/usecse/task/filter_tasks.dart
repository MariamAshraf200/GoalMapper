import '../../entity/taskEntity.dart';
import '../../repo_interface/repoTask.dart';

class FilterTasksUseCase {
  final TaskRepository repository;

  FilterTasksUseCase(this.repository);

  Future<List<TaskDetails>> call({
    required String date,
    String? priority,
    String? status,
  }) async {
    final tasks = await repository.getTasksByDate(date);

    // Apply additional filters
    final filteredTasks = tasks.where((task) {
      final matchesPriority = priority == null || task.priority == priority;
      final matchesStatus = status == null || task.status == status;
      return matchesPriority && matchesStatus;
    }).toList();

    return filteredTasks;
  }
}
