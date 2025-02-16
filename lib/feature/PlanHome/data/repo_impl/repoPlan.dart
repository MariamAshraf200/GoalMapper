import '../../domain/entities/plan_entity.dart';
import '../../domain/repo_interface/repoPlanInterface.dart';
import '../dataSource/abstractLocalDataSource.dart';
import '../model/planModel.dart';

class PlanRepositoryImpl implements PlanRepository {
  final PlanLocalDataSource dataSource;

  PlanRepositoryImpl(this.dataSource);

  @override
  Future<List<PlanDetails>> getPlans() async {
    try {
      final planModels = await dataSource.getAllPlans();
      return planModels.map((planModel) => planModel.toEntity()).toList();
    } catch (e) {
      throw Exception("Error loading plans from local data source: $e");
    }
  }

  @override
  Future<List<PlanDetails>> getPlansByCategory(String category) async {
    try {
      final planModels = await dataSource.getPlansByCategory(category);
      return planModels.map((planModel) => planModel.toEntity()).toList();
    } catch (e) {
      throw Exception("Error loading plans with category '$category': $e");
    }
  }

  @override
  Future<List<PlanDetails>> getPlansByStatus(String status) async {
    try {
      final planModels = await dataSource.getPlansByStatus(status);
      return planModels.map((planModel) => planModel.toEntity()).toList();
    } catch (e) {
      throw Exception("Error loading plans with status '$status': $e");
    }
  }

  @override
  Future<void> addPlan(PlanDetails plan) async {
    try {
      final planModel = PlanModel.fromEntity(plan);
      await dataSource.addPlan(planModel);
    } catch (e) {
      throw Exception("Error adding plan to local data source: $e");
    }
  }

  @override
  Future<void> updatePlan(PlanDetails plan) async {
    try {
      final planModel = PlanModel.fromEntity(plan);
      await dataSource.updatePlan(planModel);
    } catch (e) {
      throw Exception("Error updating plan in local data source: $e");
    }
  }

  @override
  Future<void> updatePlanPriority(String planId, String newPriority, String updatedTime) async {
    try {
      final plan = (await dataSource.getAllPlans()).firstWhere((plan) => plan.id == planId);
      final updatedPlan = plan.copyWith(
        priority: newPriority,
        updatedTime: updatedTime,
      );
      await dataSource.updatePlan(updatedPlan);
    } catch (e) {
      throw Exception("Error updating plan priority: $e");
    }
  }

  @override
  Future<void> deletePlan(String planId) async {
    try {
      await dataSource.deletePlan(planId);
    } catch (e) {
      throw Exception("Error deleting plan from local data source: $e");
    }
  }
}
