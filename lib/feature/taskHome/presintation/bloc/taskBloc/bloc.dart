import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapperapp/feature/taskHome/presintation/bloc/taskBloc/state.dart';

import '../../../domain/entity/taskEntity.dart';
import '../../../domain/entity/task_filters.dart';
import '../../../domain/usecse/task/addUsecase.dart';
import '../../../domain/usecse/task/deleteUsecase.dart';
import '../../../domain/usecse/task/filter_tasks.dart';
import '../../../domain/usecse/task/getTaskByDateUsecase.dart';
import '../../../domain/usecse/task/getTaskByPriorityUseCase.dart';
import '../../../domain/usecse/task/getTaskBystatus.dart';
import '../../../domain/usecse/task/getUsecase.dart';
import '../../../domain/usecse/task/updateStatues.dart';
import '../../../domain/usecse/task/updateUsecase.dart';
import 'event.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetAllTasksUseCase getAllTasksUseCase;
  final GetTasksByStatusUseCase getTasksByStatusUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final UpdateTaskStatusUseCase updateTaskStatusUseCase;
  final GetTasksByPriorityUseCase getTasksByPriorityUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final GetTasksByDateUseCase getTasksByDateUseCase;
  final FilterTasksUseCase filterTasksUseCase;

  // Add properties to store selected filters
  String? _selectedPriority;
  String? _selectedStatus;

  String? get selectedPriority => _selectedPriority;
  String? get selectedStatus => _selectedStatus;

  TaskBloc({
    required this.getAllTasksUseCase,
    required this.getTasksByStatusUseCase,
    required this.getTasksByPriorityUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.updateTaskStatusUseCase,
    required this.deleteTaskUseCase,
    required this.getTasksByDateUseCase,
    required this.filterTasksUseCase,
  }) : super(TaskInitial()) {
    on<GetAllTasksEvent>(_onGetAllTasks);
    on<GetTasksByStatusEvent>(_onGetTasksByStatus);
    on<GetTasksByPriorityEvent>(_onGetTasksByPriority);
    on<GetTasksByDateEvent>(_onGetTasksByDate);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<UpdateTaskStatusEvent>(_onUpdateTaskStatus);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<FilterTasksEvent>(_onFilterTasks);
  }

  Future<List<TaskDetails>> _fetchAndFilterTasks(TaskFilters? filters) async {
    final tasks = await getTasksByDateUseCase(filters?.date ?? '');
    return tasks.where((task) {
      final matchesPriority =
          filters?.priority == null || task.priority == filters?.priority;
      final matchesStatus =
          filters?.status == null || task.status == filters?.status;
      return matchesPriority && matchesStatus;
    }).toList();
  }

  Future<void> _onGetAllTasks(
    GetAllTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      final tasks = await getAllTasksUseCase();
      emit(TaskLoaded(tasks,
          filters: TaskFilters(date: '', priority: null, status: null)));
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
      emit(TaskLoaded(
        tasks,
        filters: TaskFilters(date: '', priority: null, status: event.status),
      ));
    } catch (e) {
      emit(TaskError("Failed to load tasks by status: $e"));
    }
  }

  Future<void> _onGetTasksByPriority(
    GetTasksByPriorityEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      final tasks = await getTasksByPriorityUseCase(event.priority);
      emit(TaskLoaded(
        tasks,
        filters: TaskFilters(date: '', priority: event.priority, status: null),
      ));
    } catch (e) {
      emit(TaskError("Failed to load tasks by priority: $e"));
    }
  }

  Future<void> _onGetTasksByDate(
    GetTasksByDateEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      final tasks = await getTasksByDateUseCase(event.date);
      emit(TaskLoaded(
        tasks,
        filters: TaskFilters(date: event.date, priority: null, status: null),
      ));
    } catch (e) {
      emit(TaskError("Failed to load tasks by date: $e"));
    }
  }

  Future<void> _onFilterTasks(
    FilterTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      // Update selected filters
      _selectedPriority = event.priority;
      _selectedStatus = event.status;

      final filteredTasks = await _fetchAndFilterTasks(TaskFilters(
        date: event.date,
        priority: event.priority,
        status: event.status,
      ));
      emit(TaskLoaded(
        filteredTasks,
        filters: TaskFilters(
            date: event.date, priority: event.priority, status: event.status),
      ));
    } catch (e) {
      emit(TaskError("Failed to filter tasks: $e"));
    }
  }

  Future<void> _onAddTask(
    AddTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    TaskLoaded? previousState;

    try {
      if (state is TaskLoaded) {
        previousState = state as TaskLoaded;
        final updatedTasks = List<TaskDetails>.from(previousState.tasks)
          ..add(event.task);
        emit(TaskLoaded(updatedTasks, filters: previousState.filters));
      }

      await addTaskUseCase(event.task);

      final tasks = await _fetchAndFilterTasks(previousState?.filters);
      emit(TaskLoaded(tasks,
          filters: previousState?.filters ??
              TaskFilters(date: '', priority: null, status: null)));
    } catch (e) {
      if (previousState != null) {
        emit(previousState);
      }
      emit(TaskError("Failed to add task: $e"));
    }
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    TaskLoaded? previousState;

    try {
      if (state is TaskLoaded) {
        previousState = state as TaskLoaded;
        final updatedTasks = previousState.tasks.map((task) {
          return task.id == event.task.id ? event.task : task;
        }).toList();
        emit(TaskLoaded(updatedTasks, filters: previousState.filters));
      }

      await updateTaskUseCase(event.task);

      final tasks = await _fetchAndFilterTasks(previousState?.filters);
      emit(TaskLoaded(tasks,
          filters: previousState?.filters ??
              TaskFilters(date: '', priority: null, status: null)));
    } catch (e) {
      if (previousState != null) {
        emit(previousState);
      }
      emit(TaskError("Failed to update task: $e"));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    TaskLoaded? previousState;

    try {
      if (state is TaskLoaded) {
        previousState = state as TaskLoaded;
        final updatedTasks = previousState.tasks
            .where((task) => task.id != event.taskId)
            .toList();
        emit(TaskLoaded(updatedTasks, filters: previousState.filters));
      }

      await deleteTaskUseCase(event.taskId);

      final tasks = await _fetchAndFilterTasks(previousState?.filters);
      emit(TaskLoaded(tasks,
          filters: previousState?.filters ??
              TaskFilters(date: '', priority: null, status: null)));
    } catch (e) {
      if (previousState != null) {
        emit(previousState);
      }
      emit(TaskError("Failed to delete task: $e"));
    }
  }

  Future<void> _onUpdateTaskStatus(
    UpdateTaskStatusEvent event,
    Emitter<TaskState> emit,
  ) async {
    TaskLoaded? previousState;

    try {
      if (state is TaskLoaded) {
        previousState = state as TaskLoaded;
        final updatedTasks = previousState.tasks.map((task) {
          return task.id == event.taskId
              ? task.copyWith(status: event.newStatus)
              : task;
        }).toList();
        emit(TaskLoaded(updatedTasks, filters: previousState.filters));
      }

      await updateTaskStatusUseCase(event.taskId, event.newStatus);

      final tasks = await _fetchAndFilterTasks(previousState?.filters);
      emit(TaskLoaded(tasks,
          filters: previousState?.filters ??
              TaskFilters(date: '', priority: null, status: null)));
    } catch (e) {
      if (previousState != null) {
        emit(previousState);
      }
      emit(TaskError("Failed to update task status: $e"));
    }
  }
}
