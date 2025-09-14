import 'package:hive/hive.dart';
import '../../../../core/hiveServices.dart';
import '../model/planModel.dart';
import 'abstractLocalDataSource.dart';

class HivePlanLocalDataSource implements PlanLocalDataSource {
  final HiveService hiveService;

  HivePlanLocalDataSource(this.hiveService);

  Box<PlanModel> get planBox => hiveService.getPlanBox();

  @override
  Future<void> addPlan(PlanModel plan) async {
    await planBox.put(plan.id, plan);
  }

  @override
  Future<void> updatePlan(PlanModel plan) async {
    await planBox.put(plan.id, plan);
  }

  @override
  Future<void> deletePlan(String id) async {
    await planBox.delete(id);
  }

  @override
  Future<List<PlanModel>> getAllPlans() async {
    return planBox.values.toList();
  }

  @override
  Future<List<PlanModel>> getPlansByCategory(String category) async {
    return planBox.values.where((plan) => plan.category == category).toList();
  }

  @override
  Future<List<PlanModel>> getPlansByStatus(String status) async {
    return planBox.values.where((plan) => plan.status == status).toList();
  }

  // 🔹 Get all tasks for a plan
  @override
  Future<List<String>> getAllTasks(String planId) async {
    final plan = planBox.get(planId);
    return plan?.tasks ?? [];
  }

  // 🔹 Delete a task (by value)
  @override
  Future<void> deleteTask(String planId, String task) async {
    final plan = planBox.get(planId);
    if (plan != null) {
      final updatedTasks = List<String>.from(plan.tasks)..remove(task);
      final updatedPlan = plan.copyWith(tasks: updatedTasks);
      await planBox.put(planId, updatedPlan);
    }
  }

  // 🔹 Delete a task (by index)
  Future<void> deleteTaskAt(String planId, int index) async {
    final plan = planBox.get(planId);
    if (plan != null && index >= 0 && index < plan.tasks.length) {
      final updatedTasks = List<String>.from(plan.tasks)..removeAt(index);
      final updatedPlan = plan.copyWith(tasks: updatedTasks);
      await planBox.put(planId, updatedPlan);
    }
  }

  // 🔹 Add a new task
  Future<void> addTask(String planId, String task) async {
    final plan = planBox.get(planId);
    if (plan != null) {
      final updatedTasks = List<String>.from(plan.tasks)..add(task);
      final updatedPlan = plan.copyWith(tasks: updatedTasks);
      await planBox.put(planId, updatedPlan);
    }
  }
}
