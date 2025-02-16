
import '../entities/plan_entity.dart';
import '../repo_interface/repoPlanInterface.dart';

class GetPlansByCategoryUseCase {
  final PlanRepository repository;

  GetPlansByCategoryUseCase(this.repository);

  Future<List<PlanDetails>> call(String category) async {
    return await repository.getPlansByCategory(category);
  }
}
