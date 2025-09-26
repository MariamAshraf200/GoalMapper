

import '../entities/plan_entity.dart';
import '../repo_interface/repo_plan_interface.dart';

class AddPlanUseCase {
  final PlanRepository repository;

  AddPlanUseCase(this.repository);

  Future<void> call(PlanDetails plan) async {
    return await repository.addPlan(plan);
  }
}
