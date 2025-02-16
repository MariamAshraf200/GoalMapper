import '../model/planModel.dart';

abstract class PlanLocalDataSource {
  Future<void> addPlan(PlanModel plan);
  Future<void> updatePlan(PlanModel plan);
  Future<void> deletePlan(String id);
  Future<List<PlanModel>> getAllPlans();
  Future<List<PlanModel>> getPlansByCategory(String category);
  Future<List<PlanModel>> getPlansByStatus(String status); // Add this

}
