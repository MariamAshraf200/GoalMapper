

import '../entities/plan_entity.dart';
import '../repo_interface/repo_plan_interface.dart';

class UpdatePlanUseCase {
  final PlanRepository repository;

  UpdatePlanUseCase(this.repository);

  Future<void> call(PlanDetails plan) async {
    return await repository.updatePlan(plan);
  }
}
