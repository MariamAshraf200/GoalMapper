import '../../entity/taskEntity.dart';
import '../../entity/task_enum.dart';
import '../../repo_interface/repoTask.dart';

class GetTasksByStatusUseCase {
  final TaskRepository repository;

  GetTasksByStatusUseCase(this.repository);

  Future<List<TaskDetails>> call(TaskStatus? status) async {
    return await repository.getTasksByStatus(status);
  }
}
