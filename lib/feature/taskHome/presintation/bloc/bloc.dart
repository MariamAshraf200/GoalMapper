import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapper_app/feature/taskHome/domain/usecse/getTaskByDateUsecase.dart';
import 'package:mapper_app/feature/taskHome/presintation/bloc/state.dart';
import '../../../../core/hiveServices.dart';
import '../../data/model/taskModel.dart';
import '../../domain/usecse/addUsecase.dart';
import '../../domain/usecse/deleteUsecase.dart';
import '../../domain/usecse/getTaskBystatus.dart';
import '../../domain/usecse/getUsecase.dart';
import '../../domain/usecse/updateStatues.dart';
import '../../domain/usecse/updateUsecase.dart';
import 'event.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetAllTasksUseCase getAllTasksUseCase;
  final GetTasksByStatusUseCase getTasksByStatusUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final UpdateTaskStatusUseCase updateTaskStatusUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final GetTasksByDateUseCase getTasksByDateUseCase;
  final HiveService hiveService = HiveService();

  TaskBloc({
    required this.getAllTasksUseCase,
    required this.getTasksByStatusUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.updateTaskStatusUseCase,
    required this.deleteTaskUseCase,
    required this.getTasksByDateUseCase,

  }) : super(TaskInitial()) {
    on<GetAllTasksEvent>(_onGetAllTasks);
    on<GetTasksByStatusEvent>(_onGetTasksByStatus);
    on<GetTasksByDateEvent>(_onGetTasksByDate); // New event
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<UpdateTaskStatusEvent>(_onUpdateTaskStatus);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  Future<void> _onGetAllTasks(
      GetAllTasksEvent event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoading());
    try {
      final tasks = await getAllTasksUseCase();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError("Failed to load tasks: $e"));
    }
  }

  Future<void> _onGetTasksByStatus(
      GetTasksByStatusEvent event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoading());
    try {
      final tasks = await getTasksByStatusUseCase(event.status);
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError("Failed to load tasks by status: $e"));
    }
  }Future<void> _onGetTasksByDate(
      GetTasksByDateEvent event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoading());
    try {
      final tasks = await getTasksByDateUseCase(event.date);
      print('Fetched tasks: $tasks'); // Debugging: Check if tasks are fetched correctly
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError("Failed to load tasks by date: $e"));
      print(e);
    }
  }


  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final taskModel = TaskModel(
        title: event.task.title,
        description: event.task.description,
        date: event.task.date,
        time: event.task.time,
        priority: event.task.priority,
        id: event.task.id,
        status: event.task.status,
      );

      await hiveService.addTask(taskModel);
      emit(TaskAddSuccess('Task added successfully', taskModel));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateTask(
      UpdateTaskEvent event,
      Emitter<TaskState> emit,
      ) async {
    try {
      await updateTaskUseCase(event.task);
      emit(const TaskActionSuccess("Task updated successfully."));
      add(GetAllTasksEvent());
    } catch (e) {
      emit(TaskError("Failed to update task: $e"));
    }
  }

  Future<void> _onUpdateTaskStatus(
      UpdateTaskStatusEvent event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoading());
    try {
      await updateTaskStatusUseCase(event.taskId, event.newStatus);
      emit(const TaskActionSuccess("Task status updated successfully"));
      add(GetAllTasksEvent());
    } catch (e) {
      emit(TaskError("Failed to update task status: $e"));
    }
  }

  Future<void> _onDeleteTask(
      DeleteTaskEvent event,
      Emitter<TaskState> emit,
      ) async {
    try {
      await deleteTaskUseCase(event.taskId);
      emit(const TaskActionSuccess("Task deleted successfully."));
      add(GetAllTasksEvent()); // Refresh the task list
    } catch (e) {
      emit(TaskError("Failed to delete task: $e"));
    }
  }
}
