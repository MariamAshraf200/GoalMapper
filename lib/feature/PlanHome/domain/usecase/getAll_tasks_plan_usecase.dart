import '../repo_interface/repo_plan_interface.dart';

class GetAllTasksPlanUseCase {
  final PlanRepository repository;

  GetAllTasksPlanUseCase(this.repository);

  Future<List<String>> call(String planId) async {
    return await repository.getAllTasks(planId);
  }
}

