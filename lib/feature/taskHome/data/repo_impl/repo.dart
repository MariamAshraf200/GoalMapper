
import '../../domain/entity/taskEntity.dart';
import '../../domain/repo_interface/repo.dart';
import '../dataSource/localData.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl(this.localDataSource);

  @override
  Future<void> addTask(TaskEntity task) async {
    await localDataSource.addTask(task);
  }

  @override
  Future<void> deleteTask(String id) async {
    await localDataSource.deleteTask(id);
  }

  @override
  Future<List<TaskEntity>> getAllTasks() async {
    return await localDataSource.getAllTasks();
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    await localDataSource.updateTask(task);
  }
}
