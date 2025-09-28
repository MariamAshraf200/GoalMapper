import '../entities/plan_entity.dart';
import '../entities/plan_enums.dart';
import '../repo_interface/repo_plan_interface.dart';

class GetPlansByStatusUseCase {
  final PlanRepository repository;

  GetPlansByStatusUseCase(this.repository);

  Future<List<PlanDetails>> call(PlanStatus status) async {
    return await repository.getPlansByStatus(status);
  }
}
