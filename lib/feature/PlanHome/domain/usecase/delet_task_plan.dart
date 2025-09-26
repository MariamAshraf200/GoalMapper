import '../repo_interface/repo_plan_interface.dart';

class DeleteTaskAtPlanUseCase {
  final PlanRepository repository;

  DeleteTaskAtPlanUseCase(this.repository);

  Future<void> call(String planId, int index) async {
    return await repository.deleteTaskAt(planId, index);
  }
}

