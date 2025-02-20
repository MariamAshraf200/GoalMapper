
import '../repo_interface/repoPlanInterface.dart';

class DeletePlanUseCase {
  final PlanRepository repository;

  DeletePlanUseCase(this.repository);

  Future<void> call(String planId) async {
    return await repository.deletePlan(planId);
  }
}
