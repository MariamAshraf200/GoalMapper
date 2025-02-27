import '../../repo_interface/repoTask.dart';

class UpdateTaskStatusUseCase {
  final TaskRepository taskRepository;

  UpdateTaskStatusUseCase(this.taskRepository);

  Future<void> call(String taskId, String newStatus, String updatedTime) {
    return taskRepository.updateTaskStatus(taskId, newStatus, updatedTime);
  }
}
