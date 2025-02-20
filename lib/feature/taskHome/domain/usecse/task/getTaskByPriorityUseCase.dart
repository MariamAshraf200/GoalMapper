import '../../entity/taskEntity.dart';
import '../../repo_interface/repoTask.dart';

class GetTasksByPriorityUseCase {
  final TaskRepository repository;

  GetTasksByPriorityUseCase(this.repository);


  Future<List<TaskDetails>> call(String priority) async {
    return await repository.getTasksByPriority(priority);
  }
}
