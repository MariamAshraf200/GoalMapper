import '../../entity/taskEntity.dart';
import '../../entity/task_enum.dart';
import '../../repo_interface/repoTask.dart';

class GetTasksByPriorityUseCase {
  final TaskRepository repository;

  GetTasksByPriorityUseCase(this.repository);


  Future<List<TaskDetails>> call(TaskPriority? priority) async {
    return await repository.getTasksByPriority(priority);
  }
}
