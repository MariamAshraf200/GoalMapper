import '../repo_interface/repoPlanInterface.dart';

class UpdatePlanStatusUseCase {
  final PlanRepository repository;

  UpdatePlanStatusUseCase(this.repository);

  Future<void> call(String planId, String newStatus) async {
    return await repository.updatePlanStatus(planId, newStatus,);
  }
}