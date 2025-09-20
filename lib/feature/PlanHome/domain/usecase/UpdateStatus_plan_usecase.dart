
import '../repo_interface/repo_plan_interface.dart';

class UpdatePlanStatusUseCase {
  final PlanRepository repository;

  UpdatePlanStatusUseCase(this.repository);

  Future<void> call(String planId, String newStatus) async {
    return await repository.updatePlanStatus(planId, newStatus,);
  }
}