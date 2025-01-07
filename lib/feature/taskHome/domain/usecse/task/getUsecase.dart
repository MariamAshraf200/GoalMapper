
import '../../entity/taskEntity.dart';
import '../../repo_interface/repoTask.dart';

class GetAllTasksUseCase {
  final TaskRepository repository;

  GetAllTasksUseCase(this.repository);

  Future<List<TaskDetails>> call() async {
    return await repository.getTasks();
  }
}