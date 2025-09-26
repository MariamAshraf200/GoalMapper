import '../entities/plan_entity.dart';
import '../entities/taskPlan.dart';

abstract class PlanRepository {
  // 🔹 Plans CRUD
  Future<List<PlanDetails>> getPlans();
  Future<List<PlanDetails>> getPlansByCategory(String category);
  Future<List<PlanDetails>> getPlansByStatus(String status);

  Future<void> addPlan(PlanDetails plan);
  Future<void> updatePlan(PlanDetails plan);
  Future<void> updatePlanStatus(String planId, String newStatus);
  Future<void> deletePlan(String planId);

  // 🔹 Tasks inside Plan
  Future<List<TaskPlan>> getAllTasks(String planId);
  Future<void> addTask(String planId, TaskPlan task);
  Future<void> deleteTask(String planId, String task);
  Future<void> deleteTaskAt(String planId, int index);
  Future<void> updateTaskStatus(String planId, TaskPlan updatedTask);
}
