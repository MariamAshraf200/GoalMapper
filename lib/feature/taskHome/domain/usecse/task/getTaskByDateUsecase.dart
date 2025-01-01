import '../../entity/taskEntity.dart';
import '../../repo_interface/repoTask.dart';

class GetTasksByDateUseCase {
  final TaskRepository repository;

  GetTasksByDateUseCase(this.repository);

  Future<List<TaskEntity>> call(String date) async {
    return await repository.getTasksByDate(date);
  }
}
