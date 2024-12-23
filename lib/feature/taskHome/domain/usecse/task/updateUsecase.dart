import '../../entity/taskEntity.dart';
import '../../repo_interface/repoTask.dart';

class UpdateTaskUseCase {
  final TaskRepository repository;

  UpdateTaskUseCase(this.repository);

  Future<void> call(TaskEntity task) async {
    return await repository.updateTask(task);
  }
}