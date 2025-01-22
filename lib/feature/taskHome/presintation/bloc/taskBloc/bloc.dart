import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapperapp/feature/taskHome/domain/usecse/task/getTaskByPriorityUseCase.dart';
import 'package:mapperapp/feature/taskHome/presintation/bloc/taskBloc/state.dart';
import '../../../domain/entity/task_filters.dart';
import '../../../domain/usecse/task/addUsecase.dart';
import '../../../domain/usecse/task/deleteUsecase.dart';
import '../../../domain/usecse/task/filter_tasks.dart';
import '../../../domain/usecse/task/getTaskByDateUsecase.dart';
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

  Future<void> _onGetAllTasks(
      GetAllTasksEvent event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoading());
    try {
      final tasks = await getAllTasksUseCase();
      emit(TaskLoaded(
        tasks,
        filters: TaskFilters(date: '', priority: null, status: null),
      ));
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

  Future<void> _onAddTask(
      AddTaskEvent event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoading());
    try {
      await addTaskUseCase(event.task);

      final tasksForDate = await getTasksByDateUseCase(event.task.date);
      emit(TaskLoaded(
        tasksForDate,
        filters: TaskFilters(date: event.task.date, priority: null, status: null),
      ));
    } catch (e) {
      emit(TaskError("Failed to add task: $e"));
    }
  }

  Future<void> _onFilterTasks(
      FilterTasksEvent event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoading());
    try {
      final tasksForDate = await getTasksByDateUseCase(event.date);

      final filteredTasks = tasksForDate.where((task) {
        final matchesPriority =
            event.priority == null || task.priority == event.priority;
        final matchesStatus =
            event.status == null || task.status == event.status;
        return matchesPriority && matchesStatus;
      }).toList();

      emit(TaskLoaded(
        filteredTasks,
        filters: TaskFilters(
          date: event.date,
          priority: event.priority,
          status: event.status,
        ),
      ));
    } catch (e) {
      emit(TaskError("Failed to filter tasks: $e"));
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

        // Optimistically update the state
        final updatedTasks = previousState.tasks.map((task) {
          if (task.id == event.taskId) {
            return task.copyWith(status: event.newStatus);
          }
          return task;
        }).toList();

        emit(TaskLoaded(
          updatedTasks,
          filters: previousState.filters,
        ));
      }

      // Perform the actual update
      await updateTaskStatusUseCase(event.taskId, event.newStatus);
    } catch (e) {
      // Revert to the previous state on error
      if (previousState != null) {
        emit(previousState);
      }
      emit(TaskError("Failed to update task status: $e"));
    }
  }



  Future<void> _onUpdateTask(
      UpdateTaskEvent event,
      Emitter<TaskState> emit,
      ) async {
    try {
      await updateTaskUseCase(event.task);
      emit(const TaskActionSuccess("Task updated successfully."));
    } catch (e) {
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

        final updatedTasks = previousState.tasks.where((task) {
          return task.id != event.taskId;
        }).toList();

        emit(TaskLoaded(updatedTasks, filters: previousState.filters));
      }

      await deleteTaskUseCase(event.taskId);

      final tasks = await getTasksByDateUseCase(previousState?.filters.date ?? '');
      final filteredTasks = tasks.where((task) {
        final matchesStatus = previousState?.filters.status == null || task.status == previousState?.filters.status;
        final matchesPriority = previousState?.filters.priority == null || task.priority == previousState?.filters.priority;
        return matchesStatus && matchesPriority;
      }).toList();

      emit(TaskLoaded(filteredTasks, filters: previousState?.filters ?? TaskFilters(date: '', priority: null, status: null)));
    } catch (e) {
      emit(TaskError("Failed to delete task: $e"));
    }
  }

}
