import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapper_app/feature/taskHome/presintation/bloc/state.dart';
import '../../data/model/taskModel.dart';
import '../../domain/usecse/addUsecase.dart';
import '../../domain/usecse/deleteUsecase.dart';
import '../../domain/usecse/getUsecase.dart';
import '../../domain/usecse/updateUsecase.dart';
import 'event.dart';
import '../../domain/entity/taskEntity.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  late Box<TaskEntity> taskBox;
  GetAllTasksUseCase getAllTasksUseCase;
  UpdateTaskUseCase updateTaskUseCase;
  AddTaskUseCase addTaskUseCase;
  DeleteTaskUseCase deleteTaskUseCase;

  TaskBloc(
      {required this.getAllTasksUseCase,
      required this.addTaskUseCase,
      required  this.updateTaskUseCase,
      required this.deleteTaskUseCase})
      : super(TaskInitial()) {
    on<GetTasksEvent>(_onGetTasksEvent);
    on<AddTaskEvent>(_onAddTaskEvent);
    on<UpdateTaskEvent>(_onUpdateTaskEvent);
    on<DeleteTaskEvent>(_onDeleteTaskEvent);
    on<MarkTaskAsDoneEvent>(_onMarkTaskAsDoneEvent);
    on<ChangeTaskStatusEvent>(_onChangeTaskStatusEvent);
    on<ClearAllTasksEvent>(_onClearAllTasksEvent);
  }

  Future<void> _onGetTasksEvent(
      GetTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = taskBox.values.toList();
      if (event.status != null) {
        final filteredTasks =
            tasks.where((task) => task.status == event.status).toList();
        emit(TaskLoaded(tasks: filteredTasks));
      } else {
        if (tasks.isNotEmpty) {
          emit(TaskLoaded(tasks: tasks));
        } else {
          emit(TaskError(message: "No tasks found"));
        }
      }
    } catch (_) {
      emit(TaskError(message: "An error occurred while loading tasks"));
    }
  }

  Future<void> _onAddTaskEvent(AddTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await taskBox.add(TaskModel(
        id: event.task.id,
        title: event.task.title,
        description: event.task.description,
        date: event.task.date,
        time: event.task.time,
        priority: event.task.priority,
        status: event.task.status,
      ) as TaskEntity);

      print("Task added to Hive successfully.");

      // Fetch all tasks from Hive after adding
      final tasks = taskBox.values.toList();
      print("Number of tasks in Hive: ${tasks.length}"); // Debugging line
      emit(TaskLoaded(tasks: tasks));
    } catch (e) {
      print("Error while adding task: $e"); // Debugging line
      emit(TaskError(message: "An error occurred while adding a task"));
    }
  }


  Future<void> _onUpdateTaskEvent(
      UpdateTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final taskIndex =
          taskBox.values.toList().indexWhere((task) => task.id == event.taskId);
      if (taskIndex != -1) {
        await taskBox.putAt(taskIndex, event.updatedTask);
        final tasks = taskBox.values.toList();
        emit(TaskLoaded(tasks: tasks));
      } else {
        emit(TaskError(message: "Task not found for updating"));
      }
    } catch (_) {
      emit(TaskError(message: "An error occurred while updating the task"));
    }
  }

  Future<void> _onDeleteTaskEvent(
      DeleteTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final taskIndex =
          taskBox.values.toList().indexWhere((task) => task.id == event.taskId);
      if (taskIndex != -1) {
        await taskBox.deleteAt(taskIndex);
        final tasks = taskBox.values.toList();
        emit(TaskLoaded(tasks: tasks));
      } else {
        emit(TaskError(message: "Task not found for deletion"));
      }
    } catch (_) {
      emit(TaskError(message: "An error occurred while deleting the task"));
    }
  }

  Future<void> _onMarkTaskAsDoneEvent(
      MarkTaskAsDoneEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final taskIndex =
          taskBox.values.toList().indexWhere((task) => task.id == event.taskId);
      if (taskIndex != -1) {
        final task = taskBox.getAt(taskIndex)!;
        final updatedTask = task.copyWith(status: 'Done');
        await taskBox.putAt(taskIndex, updatedTask);

        final tasks = taskBox.values.toList();
        emit(TaskLoaded(tasks: tasks));
      } else {
        emit(TaskError(message: "Task not found to mark as done"));
      }
    } catch (_) {
      emit(TaskError(message: "An error occurred while marking task as done"));
    }
  }

  Future<void> _onChangeTaskStatusEvent(
      ChangeTaskStatusEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final taskIndex =
          taskBox.values.toList().indexWhere((task) => task.id == event.taskId);
      if (taskIndex != -1) {
        final task = taskBox.getAt(taskIndex)!;
        final updatedTask = task.copyWith(status: event.newStatus);
        await taskBox.putAt(taskIndex, updatedTask);

        final tasks = taskBox.values.toList();
        emit(TaskLoaded(tasks: tasks));
      } else {
        emit(TaskError(message: "Task not found to change status"));
      }
    } catch (_) {
      emit(TaskError(message: "An error occurred while changing task status"));
    }
  }

  Future<void> _onClearAllTasksEvent(
      ClearAllTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await taskBox.clear();
      emit(TaskLoaded(tasks: []));
    } catch (_) {
      emit(TaskError(message: "An error occurred while clearing tasks"));
    }
  }
}
