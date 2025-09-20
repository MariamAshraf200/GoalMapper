

import '../repo_interface/repo_plan_interface.dart';

class DeletePlanUseCase {
  final PlanRepository repository;

  DeletePlanUseCase(this.repository);

  Future<void> call(String planId) async {
    return await repository.deletePlan(planId);
  }
}
