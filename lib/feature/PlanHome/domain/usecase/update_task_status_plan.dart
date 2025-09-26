import '../entities/taskPlan.dart';
import '../repo_interface/repo_plan_interface.dart';

class UpdateTaskStatusPlanUseCase {
  final PlanRepository repository;

  UpdateTaskStatusPlanUseCase(this.repository);

  Future<void> call(String planId, TaskPlan updatedTask) {
    return repository.updateTaskStatus(planId, updatedTask);
  }
}
