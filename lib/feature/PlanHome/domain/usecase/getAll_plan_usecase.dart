

import '../entities/plan_entity.dart';
import '../repo_interface/repoPlanInterface.dart';

class GetAllPlansUseCase {
  final PlanRepository repository;

  GetAllPlansUseCase(this.repository);

  Future<List<PlanDetails>> call() async {
    return await repository.getPlans();
  }
}
