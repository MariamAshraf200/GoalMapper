import '../model/planModel.dart';

abstract class PlanLocalDataSource {
  // 🔹 CRUD for Plan
  Future<void> addPlan(PlanModel plan);
  Future<void> updatePlan(PlanModel plan);
  Future<void> deletePlan(String id);
  Future<List<PlanModel>> getAllPlans();
  Future<List<PlanModel>> getPlansByCategory(String category);
  Future<List<PlanModel>> getPlansByStatus(String status);

  // 🔹 Tasks inside a Plan
  Future<List<String>> getAllTasks(String planId);
  Future<void> deleteTask(String planId, String task);
}
