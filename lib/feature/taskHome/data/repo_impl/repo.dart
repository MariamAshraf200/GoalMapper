import '../../domain/entity/taskEntity.dart';
import '../../domain/repo_interface/repo.dart';
import '../dataSource/localData.dart';
import '../model/taskModel.dart';  // Task storage model (Hive model)

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl(this.localDataSource);

  @override
  Future<void> addTask(TaskEntity taskEntity) async {
    TaskModel taskModel = TaskModel.fromEntity(taskEntity); // Convert Entity to Model
    await localDataSource.addTask(taskModel); // Pass Model to Data Source
  }

  @override
  Future<void> deleteTask(String id) async {
    await localDataSource.deleteTask(id); // Directly interact with local data source
  }

  @override
  Future<List<TaskEntity>> getAllTasks() async {
    List<TaskModel> taskModels = await localDataSource.getAllTasks();  // Get List of Models
    return taskModels.map((taskModel) => taskModel.toEntity()).toList(); // Convert to List of Entities
  }

  @override
  Future<void> updateTask(TaskEntity taskEntity) async {
    TaskModel taskModel = TaskModel.fromEntity(taskEntity); // Convert Entity to Model
    await localDataSource.updateTask(taskModel); // Pass Model to Data Source
  }
}
