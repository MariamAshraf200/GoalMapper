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
}
