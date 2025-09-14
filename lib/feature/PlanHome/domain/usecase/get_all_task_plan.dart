import '../repo_interface/repoPlanInterface.dart';

class GetAllTasksPlanUseCase {
  final PlanRepository repository;

  GetAllTasksPlanUseCase(this.repository);

  Future<List<String>> call(String planId) async {
    return await repository.getAllTasks(planId);
  }
}
