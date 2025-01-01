import '../../entity/taskEntity.dart';
import '../../repo_interface/repoTask.dart';

class GetTasksByStatusUseCase {
  final TaskRepository repository;

  GetTasksByStatusUseCase(this.repository);

  Future<List<TaskDetails>> call(String status) async {
    return await repository.getTasksByStatus(status);
  }
}
