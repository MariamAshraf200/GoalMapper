import 'package:dartz/dartz.dart' as dartz;

import '../../../../core/failure.dart';
import '../entity/taskEntity.dart';
import '../repo_interface/repo.dart';

class GetAllTasksUseCase {
  final TaskRepository repository;

  GetAllTasksUseCase(this.repository);

  Future<dartz.Either<Failure, List<TaskEntity>>> call() async {
    try {
      final tasks = await repository.getAllTasks();
      return dartz.Right(tasks);
    } catch (e) {
      return dartz.Left(Failure(message: e.toString()));
    }
  }
}
