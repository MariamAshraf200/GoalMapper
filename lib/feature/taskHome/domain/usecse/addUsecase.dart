import '../entity/taskEntity.dart';
import '../repo_interface/repo.dart';

class AddTaskUseCase {
  final TaskRepository repository;

  AddTaskUseCase(this.repository);

  Future<void> call(TaskEntity task) async {
    return await repository.addTask(task);
  }
}
