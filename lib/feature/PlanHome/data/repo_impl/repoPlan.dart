import 'package:flutter/foundation.dart';

import '../../domain/entities/plan_entity.dart';
import '../../domain/entities/plan_enums.dart';
import '../../domain/entities/taskPlan.dart';
import '../../domain/repo_interface/repo_plan_interface.dart';
import '../dataSource/abstractLocalDataSource.dart';
import '../dataSource/localData.dart';
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
  Future<List<PlanDetails>> getPlansByStatus(PlanStatus status) async {
    final planModels = await dataSource.getAllPlans();
    List<PlanModel> filtered;
    switch (status) {
      case PlanStatus.completed:
        filtered = planModels.where((p) => p.completed == true).toList();
        break;
      case PlanStatus.notCompleted:
        filtered = planModels.where((p) => p.completed == false).toList();
        break;
      case PlanStatus.all:
      filtered = planModels;
    }
    return filtered.map((planModel) => planModel.toEntity()).toList();
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
  Future<void> updatePlanStatus(String planId, String newStatus) async {
    try {
      final plan = (await dataSource.getAllPlans())
          .firstWhere((plan) => plan.id == planId);
      final updatedPlan = plan.copyWith(
        status: newStatus,
      );
      await dataSource.updatePlan(updatedPlan);
    } catch (e) {
      throw Exception("Error updating plan status: $e");
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

  @override
  Future<List<TaskPlan>> getAllTasks(String planId) async {
    try {
      final rawTasks = await dataSource.getAllTasks(planId);
      return rawTasks;
    } catch (e) {
      if (kDebugMode) debugPrint("Error while loading tasks: $e");
      throw Exception("Error loading tasks for plan '$planId': $e");
    }
  }

  // 🔹 Add a task to a plan
  Future<void> addTask(String planId, TaskPlan task) async {
    try {
      if (dataSource is HivePlanLocalDataSource) {
        await (dataSource as HivePlanLocalDataSource).addTask(planId, task);
      }
    } catch (e) {
      throw Exception("Error adding task to plan '$planId': $e");
    }
  }

  // 🔹 Delete a task by value
  Future<void> deleteTask(String planId, String task) async {
    try {
      await dataSource.deleteTask(planId, task);
    } catch (e) {
      throw Exception("Error deleting task from plan '$planId': $e");
    }
  }

  // 🔹 Delete a task by index
  Future<void> deleteTaskAt(String planId, int index) async {
    try {
      if (dataSource is HivePlanLocalDataSource) {
        await (dataSource as HivePlanLocalDataSource)
            .deleteTaskAt(planId, index);
      }
    } catch (e) {
      throw Exception(
          "Error deleting task at index $index from plan '$planId': $e");
    }
  }

  @override
  Future<void> updateTaskStatus(String planId, TaskPlan updatedTask) async {
    await dataSource.updateTaskStatus(planId, updatedTask);
  }
}
