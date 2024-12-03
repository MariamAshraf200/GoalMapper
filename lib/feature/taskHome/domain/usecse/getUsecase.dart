
import '../entity/taskEntity.dart';
import '../repo_interface/repo.dart';

class GetAllTasksUseCase {
  final TaskRepository repository;

  GetAllTasksUseCase(this.repository);

  Future<List<TaskEntity>> call() async {
    return await repository.getAllTasks();
  }
}