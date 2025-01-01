
import '../../repo_interface/repoTask.dart';

class DeleteTaskUseCase {
  final TaskRepository repository;

  DeleteTaskUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteTask(id);
  }
}