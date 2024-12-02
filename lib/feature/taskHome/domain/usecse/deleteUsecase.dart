
import '../repo_interface/repo.dart';

class DeleteTaskUseCase {
  final TaskRepository repository;

  DeleteTaskUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteTask(id);
  }
}