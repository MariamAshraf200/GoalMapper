

import '../entities/plan_entity.dart';
import '../repo_interface/repoPlanInterface.dart';

class AddPlanUseCase {
  final PlanRepository repository;

  AddPlanUseCase(this.repository);

  Future<void> call(PlanDetails plan) async {
    return await repository.addPlan(plan);
  }
}
