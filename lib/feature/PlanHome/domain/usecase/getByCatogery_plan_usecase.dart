
import '../entities/plan_entity.dart';
import '../repo_interface/repo_plan_interface.dart';

class GetPlansByCategoryUseCase {
  final PlanRepository repository;

  GetPlansByCategoryUseCase(this.repository);

  Future<List<PlanDetails>> call(String category) async {
    return await repository.getPlansByCategory(category);
  }
}
