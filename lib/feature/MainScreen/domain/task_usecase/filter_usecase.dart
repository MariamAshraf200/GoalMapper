import 'package:mapperapp/feature/taskHome/domain/repo_interface/repoTask.dart';
import 'package:mapperapp/feature/taskHome/domain/entity/task_filters.dart';
import 'package:mapperapp/feature/taskHome/domain/entity/taskEntity.dart';

class FilterMainTasksUseCase {
  final TaskRepository repository;

  FilterMainTasksUseCase(this.repository);

  Future<List<TaskDetails>> call(TaskFilters filters) async {
    final tasks = await repository.getTasksByDate(filters.date!);
    return tasks.where((task) {
      final matchesPriority = filters.priority == null || task.priority == filters.priority;
      final matchesStatus = filters.status == null || task.status == filters.status;
      return matchesPriority && matchesStatus;
    }).toList();
  }
}
