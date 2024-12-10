import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapper_app/feature/taskHome/presintation/bloc/state.dart';
import '../../../../core/hiveServices.dart';
import '../../data/model/taskModel.dart';
import '../../domain/usecse/addUsecase.dart';
import '../../domain/usecse/deleteUsecase.dart';
import '../../domain/usecse/getTaskBystatus.dart';
import '../../domain/usecse/getUsecase.dart';
import '../../domain/usecse/updateUsecase.dart';
import 'event.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetAllTasksUseCase getAllTasksUseCase;
  final GetTasksByStatusUseCase getTasksByStatusUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final hiveService = HiveService();

  TaskBloc({
    required this.getAllTasksUseCase,
    required this.getTasksByStatusUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
  }) : super(TaskInitial()) {
    on<GetAllTasksEvent>(_onGetAllTasks);
    on<GetTasksByStatusEvent>(_onGetTasksByStatus);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
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
      add(GetAllTasksEvent()); // Refresh the task list
    } catch (e) {
      emit(TaskError("Failed to update task: $e"));
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
