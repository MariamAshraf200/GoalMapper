import 'package:mapper_app/feature/taskHome/domain/entity/taskEntity.dart';
import '../../repo_interface/repoTask.dart';

class GetTasksByDateUseCase {
  final TaskRepository repository;

  GetTasksByDateUseCase(this.repository);

  Future<List<TaskDetails>> call(String date) async {
    return await repository.getTasksByDate(date);
  }
}
