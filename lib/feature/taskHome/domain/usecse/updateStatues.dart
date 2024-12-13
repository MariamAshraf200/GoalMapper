import '../repo_interface/repo.dart';

class UpdateTaskStatusUseCase {
  final TaskRepository taskRepository;

  UpdateTaskStatusUseCase(this.taskRepository);

  Future<void> call(String taskId, String newStatus) {
    return taskRepository.updateTaskStatus(taskId, newStatus);
  }
}
