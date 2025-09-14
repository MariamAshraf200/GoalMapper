import '../repo_interface/repoPlanInterface.dart';

class AddTaskPlanUseCase {
  final PlanRepository repository;

  AddTaskPlanUseCase(this.repository);

  Future<void> call(String planId, String task) async {
    return await repository.addTask(planId, task);
  }
}
