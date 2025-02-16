import '../entities/plan_entity.dart';

abstract class PlanRepository {
  Future<List<PlanDetails>> getPlans();


  Future<List<PlanDetails>> getPlansByCategory(String category);

  Future<void> addPlan(PlanDetails plan);

  Future<void> updatePlan(PlanDetails plan);

  Future<List<PlanDetails>> getPlansByStatus(String status); // Add this method


  Future<void> updatePlanPriority(String planId, String newPriority, String updatedTime);

  Future<void> deletePlan(String planId);
}
