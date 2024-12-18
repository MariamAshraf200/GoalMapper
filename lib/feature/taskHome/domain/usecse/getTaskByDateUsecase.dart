import 'package:mapper_app/feature/taskHome/domain/entity/taskEntity.dart';
import '../repo_interface/repo.dart';

class GetTasksByDateUseCase {
  final TaskRepository repository;

  GetTasksByDateUseCase(this.repository);

  Future<List<TaskEntity>> call(String date) async {
    return await repository.getTasksByDate(date);
  }
}