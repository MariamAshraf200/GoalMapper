import '../repo_interface/repo_plan_interface.dart';

class AddTaskPlanUseCase {
  final PlanRepository repository;

  AddTaskPlanUseCase(this.repository);

  Future<void> call(String planId, String task) async {
    return await repository.addTask(planId, task);
  }
}

