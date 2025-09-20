import '../../domain/entities/plan_entity.dart';
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

  // 🔹 Get all tasks of a plan
  Future<List<String>> getAllTasks(String planId) async {
    try {
      return await dataSource.getAllTasks(planId);
    } catch (e) {
      throw Exception("Error loading tasks for plan '$planId': $e");
    }
  }

  // 🔹 Add a task to a plan
  Future<void> addTask(String planId, String task) async {
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
}
