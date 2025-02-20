import '../../entity/taskEntity.dart';
import '../../repo_interface/repoTask.dart';

class GetTasksByPlanIdUseCase {
  final TaskRepository repository;

  GetTasksByPlanIdUseCase(this.repository);

  Future<List<TaskDetails>> call(String planId) async {
    return await repository.getTasksByPlanId(planId);
  }
}