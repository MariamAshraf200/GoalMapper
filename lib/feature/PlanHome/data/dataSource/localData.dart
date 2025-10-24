import 'package:hive/hive.dart';
import '../../../../core/network/hiveServices.dart';
import '../../domain/entities/plan_enums.dart';
import '../../domain/entities/taskPlan.dart';
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
  Future<List<PlanModel>> getPlansByStatus(PlanStatus status) async {
    final allPlans = await getAllPlans();
    switch (status) {
      case PlanStatus.completed:
        return allPlans.where((p) => p.completed == true).toList();
      case PlanStatus.notCompleted:
        return allPlans.where((p) => p.completed == false).toList();
      case PlanStatus.all:
      return allPlans;
    }
  }

  // 🔹 Get all tasks for a plan
  @override
  Future<List<TaskPlan>> getAllTasks(String planId) async {
    final plan = planBox.get(planId);
    if (plan == null) return [];
    return plan.tasks;
  }

  // 🔹 Delete a task (by value)
  @override
  Future<void> deleteTask(String planId, String taskId) async {
    final plan = planBox.get(planId);
    if (plan != null) {
      final updatedTasks = plan.tasks.where((t) => t.id != taskId).toList();
      final updatedPlan = plan.copyWith(tasks: updatedTasks);
      await planBox.put(planId, updatedPlan);
    }
  }

  // 🔹 Delete a task (by index)
  @override
  Future<void> deleteTaskAt(String planId, int index) async {
    final plan = planBox.get(planId);
    if (plan != null && index >= 0 && index < plan.tasks.length) {
      final updatedTasks = List<TaskPlan>.from(plan.tasks)..removeAt(index);
      final updatedPlan = plan.copyWith(tasks: updatedTasks);
      await planBox.put(planId, updatedPlan);
    }
  }

  // 🔹 Add a new task
  @override
  Future<void> addTask(String planId, TaskPlan task) async {
    final plan = planBox.get(planId);
    if (plan != null) {
      final updatedTasks = List<TaskPlan>.from(plan.tasks)..add(task);
      final updatedPlan = plan.copyWith(tasks: updatedTasks);
      await planBox.put(planId, updatedPlan);
    }
  }

  @override
  Future<void> updateTaskStatus(String planId, TaskPlan updatedTask) async {
    final plan = planBox.get(planId);
    if (plan != null) {
      final updatedTasks = plan.tasks.map((t) {
        if (t.id == updatedTask.id) {
          return updatedTask;
        }
        return t;
      }).toList();
      final updatedPlan = plan.copyWith(tasks: updatedTasks);
      await planBox.put(planId, updatedPlan);
    }
  }
}
