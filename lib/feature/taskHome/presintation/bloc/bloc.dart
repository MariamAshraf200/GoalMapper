import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapper_app/feature/taskHome/presintation/bloc/state.dart';
import '../../data/model/taskModel.dart';
import 'event.dart';
import '../../domain/entity/taskEntity.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  late Box<TaskEntity> taskBox;

  TaskBloc() : super(TaskInitial()) {
    on<GetTasksEvent>(_onGetTasksEvent);
    on<AddTaskEvent>(_onAddTaskEvent);
    on<UpdateTaskEvent>(_onUpdateTaskEvent);
    on<DeleteTaskEvent>(_onDeleteTaskEvent);
  }

  // Open the Hive box when the bloc is initialized
  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskModelAdapter());
    taskBox = await Hive.openBox<TaskEntity>('tasks');
  }

  // Event handler for loading tasks
  Future<void> _onGetTasksEvent(GetTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = taskBox.values.toList();
      if (tasks.isNotEmpty) {
        emit(TaskLoaded(tasks: tasks)); // Emit TaskLoaded with the list of tasks
      } else {
        emit(TaskError(message: "No tasks found"));
      }
    } catch (_) {
      emit(TaskError(message: "An error occurred while loading tasks"));
    }
  }

  // Event handler for adding a new task
  Future<void> _onAddTaskEvent(AddTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      // Add task to Hive
      await taskBox.add(event.task);

      emit(TaskAddedSuccess(message: "Task successfully added"));

      // Fetch all tasks from Hive after adding
      final tasks = taskBox.values.toList();
      emit(TaskLoaded(tasks: tasks));
    } catch (_) {
      emit(TaskError(message: "An error occurred while adding a task"));
    }
  }

  // Event handler for updating a task
  Future<void> _onUpdateTaskEvent(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final taskIndex = taskBox.values.toList().indexWhere((task) => task.id == event.task.id);
      if (taskIndex != -1) {
        await taskBox.putAt(taskIndex, event.task);
        final tasks = taskBox.values.toList();
        emit(TaskLoaded(tasks: tasks));
      } else {
        emit(TaskError(message: "Task not found for updating"));
      }
    } catch (_) {
      emit(TaskError(message: "An error occurred while updating the task"));
    }
  }

  // Event handler for deleting a task
  Future<void> _onDeleteTaskEvent(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final taskIndex = taskBox.values.toList().indexWhere((task) => task.id == event.taskId);
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
}
