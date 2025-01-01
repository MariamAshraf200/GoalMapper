import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mapperapp/feature/taskHome/presintation/bloc/taskBloc/state.dart';
import '../../../../../core/hiveServices.dart';
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

// class TaskBloc extends Bloc<TaskEvent, TaskState> {
//   final GetAllTasksUseCase getAllTasksUseCase;
//   final GetTasksByStatusUseCase getTasksByStatusUseCase;
//   final AddTaskUseCase addTaskUseCase;
//   final UpdateTaskUseCase updateTaskUseCase;
//   final UpdateTaskStatusUseCase updateTaskStatusUseCase;
//   final DeleteTaskUseCase deleteTaskUseCase;
//   final GetTasksByDateUseCase getTasksByDateUseCase;
//   final FilterTasksUseCase filterTasksUseCase;
//   final HiveService hiveService = HiveService();
//
//   TaskBloc({
//     required this.getAllTasksUseCase,
//     required this.getTasksByStatusUseCase,
//     required this.addTaskUseCase,
//     required this.updateTaskUseCase,
//     required this.updateTaskStatusUseCase,
//     required this.deleteTaskUseCase,
//     required this.getTasksByDateUseCase,
//     required this.filterTasksUseCase,
//
//   }) : super(TaskInitial()) {
//     on<GetAllTasksEvent>(_onGetAllTasks);
//     on<GetTasksByStatusEvent>(_onGetTasksByStatus);
//     on<GetTasksByDateEvent>(_onGetTasksByDate);
//     on<AddTaskEvent>(_onAddTask);
//     on<UpdateTaskEvent>(_onUpdateTask);
//     on<UpdateTaskStatusEvent>(_onUpdateTaskStatus);
//     on<DeleteTaskEvent>(_onDeleteTask);
//     on<FilterTasksEvent>(_onFilterTasks);
//   }
//
//   Future<void> _onGetAllTasks(
//       GetAllTasksEvent event,
//       Emitter<TaskState> emit,
//       ) async {
//     emit(TaskLoading());
//     try {
//       final tasks = await getAllTasksUseCase();
//       emit(TaskLoaded(tasks));
//     } catch (e) {
//       emit(TaskError("Failed to load tasks: $e"));
//     }
//   }
//
//   Future<void> _onGetTasksByStatus(
//       GetTasksByStatusEvent event,
//       Emitter<TaskState> emit,
//       ) async {
//     emit(TaskLoading());
//     try {
//       final tasks = await getTasksByStatusUseCase(event.status);
//       emit(TaskLoaded(tasks));
//     } catch (e) {
//       emit(TaskError("Failed to load tasks by status: $e"));
//     }
//   }
//
//
//   Future<void> _onGetTasksByDate(
//       GetTasksByDateEvent event,
//       Emitter<TaskState> emit,
//       ) async {
//     emit(TaskLoading());
//     try {
//      // print('Requested date: ${event.date}');
//       final tasks = await getTasksByDateUseCase(event.date);
//       print('Raw fetched tasks: $tasks'); // Should now print detailed task information
//       emit(TaskLoaded(tasks));
//     } catch (e) {
//       emit(TaskError("Failed to load tasks by date: $e"));
//       print(e);
//     }
//   }
//
//   // Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
//   //   emit(TaskLoading());
//   //   try {
//   //     final taskModel = TaskModel(
//   //       category: event.task.category,
//   //       title: event.task.title,
//   //       description: event.task.description,
//   //       date: event.task.date,
//   //       time: event.task.time,
//   //       priority: event.task.priority,
//   //       id: event.task.id,
//   //       status: event.task.status,
//   //     );
//   //
//   //     await hiveService.addTask(taskModel);
//   //     /// //fetching string test
//   //     // final allTasks = await hiveService.getTasks();
//   //     // if (kDebugMode) {
//   //     //   print("All tasks in Hive: $allTasks");
//   //     // } // Debug: Print all tasks in Hive
//   //     final tasksForSelectedDate = await hiveService.getTasksByDate(event.task.date);
//   //     // Fetch updated tasks
//   //     final formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
//   //     add(GetTasksByDateEvent(formattedDate));
//   //     emit(TaskAddSuccess('Task added successfully', taskModel));
//   //   } catch (e) {
//   //     print("Error adding task: $e"); // Debug: Print any errors
//   //     emit(TaskError(e.toString()));
//   //   }
//   // }
//
//   Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
//     emit(TaskLoading()); // Show loading state while adding the task
//     try {
//       final taskModel = event.task.toModel();
//       // final taskModel = TaskModel(
//       //   category: event.task.category,
//       //   title: event.task.title,
//       //   description: event.task.description,
//       //   date: event.task.date,
//       //   time: event.task.time,
//       //   priority: event.task.priority,
//       //   id: event.task.id,
//       //   status: event.task.status,
//       // );
//       // Save the task to Hive
//       await hiveService.addTask(taskModel);
//
//       // Fetch updated tasks for the selected date
//       final tasksForSelectedDate = await hiveService.getTasksByDate(event.task.date);
//
//       // Map TaskModel to TaskDetails
//       // final tasksForSelectedDateDetails = tasksForSelectedDate.map((task) {
//       //   return TaskDetails(
//       //     category: task.category,
//       //     title: task.title,
//       //     description: task.description,
//       //     date: task.date,
//       //     time: task.time,
//       //     priority: task.priority,
//       //     id: task.id,
//       //     status: task.status,
//       //   );
//       // }).toList();
//
//       final tasksForSelectedDateDetails =
//       tasksForSelectedDate.map((task) => task.toEntity()).toList();
//
//
//       // Emit a success state and the updated task list
//       emit(TaskAddSuccess('Task added successfully', taskModel));
//       emit(TaskLoaded(tasksForSelectedDateDetails));
//       add(GetTasksByDateEvent(event.task.date));
//     } catch (e) {
//       // Handle errors gracefully
//       print("Error adding task: $e"); // Debug: Log the error
//       emit(TaskError("Failed to add task: $e"));
//     }
//   }
//
//   Future<void> _onFilterTasks(
//       FilterTasksEvent event,
//       Emitter<TaskState> emit,
//       ) async {
//     emit(TaskLoading()); // Emit loading state
//     try {
//       // Fetch tasks for the given date
//       final tasksForDate = await getTasksByDateUseCase(event.date);
//       if (kDebugMode) {
//         // print('status: ${event.date}');
//         // print('status: ${event.status}');
//         //print('Raw fetched tasks: $tasksForDate');
//       }
//       if (tasksForDate.isEmpty) {
//         emit(const TaskLoaded([]));
//         return;
//       }
//
//       // Apply additional filters (priority and status)
//       final filteredTasks = tasksForDate.where((task) {
//         final matchesPriority =
//             event.priority == null || task.priority == event.priority;
//         print('matches Priority: ${task.priority}');
//         final matchesStatus =
//             event.status == null || task.status == event.status;
//         print('matches Priority: ${task.status}');
//         return matchesPriority && matchesStatus;
//       }).toList();
//
//       if (filteredTasks.isEmpty) {
//         // Log if filtering resulted in no matches
//         print("No tasks match the applied filters: "
//             "Priority = ${event.priority}, Status = ${event.status}");
//       }
//
//       emit(TaskLoaded(filteredTasks,)); // Emit the filtered tasks
//     } catch (e, stackTrace) {
//       // Log the error and stack trace for debugging
//       if (kDebugMode) {
//         print("Error occurred during filtering: $e");
//       }
//       if (kDebugMode) {
//         print(stackTrace);
//       }
//
//       emit(TaskError("Failed to filter tasks: $e"));
//     }
//   }
//
//
//
//   Future<void> _onUpdateTask(
//       UpdateTaskEvent event,
//       Emitter<TaskState> emit,
//       ) async {
//     try {
//       await updateTaskUseCase(event.task);
//       emit(const TaskActionSuccess("Task updated successfully."));
//       add(GetAllTasksEvent());
//     } catch (e) {
//       emit(TaskError("Failed to update task: $e"));
//     }
//   }
//
//   // Future<void> _onUpdateTaskStatus(
//   //     UpdateTaskStatusEvent event,
//   //     Emitter<TaskState> emit,
//   //     ) async {
//   //   emit(TaskLoading());
//   //   try {
//   //     await updateTaskStatusUseCase(event.taskId, event.newStatus);
//   //     emit(const TaskActionSuccess("Task status updated successfully"));
//   //     add(GetAllTasksEvent());
//   //   } catch (e) {
//   //     emit(TaskError("Failed to update task status: $e"));
//   //   }
//   // }
//   Future<void> _onUpdateTaskStatus(
//       UpdateTaskStatusEvent event,
//       Emitter<TaskState> emit,
//       ) async {
//     emit(TaskLoading());
//     try {
//       // Update the task status in the repository
//       await updateTaskStatusUseCase(event.taskId, event.newStatus);
//
//       // Use the current filters to refresh the list
//       final currentState = state;
//       if (currentState is TaskLoaded) {
//         final currentFilters = currentState.filters; // Capture current filters
//         final tasksForDate = await getTasksByDateUseCase(currentFilters.date);
//
//         // Reapply filters (priority, status)
//         final filteredTasks = tasksForDate.where((task) {
//           final matchesPriority =
//               currentFilters.priority == null ||
//                   task.priority == currentFilters.priority;
//           final matchesStatus =
//               currentFilters.status == null ||
//                   task.status == currentFilters.status;
//           return matchesPriority && matchesStatus;
//         }).toList();
//
//         emit(TaskLoaded(filteredTasks));
//       } else {
//         // Fallback: Fetch tasks for today's date if no filters exist
//         final tasks = await getTasksByDateUseCase(
//             DateFormat('dd/MM/yyyy').format(DateTime.now()));
//         emit(TaskLoaded(tasks));
//       }
//     } catch (e) {
//       emit(TaskError("Failed to update task status: $e"));
//     }
//   }
//
//
//
//   Future<void> _onDeleteTask(
//       DeleteTaskEvent event,
//       Emitter<TaskState> emit,
//       ) async {
//     try {
//       await deleteTaskUseCase(event.taskId);
//       emit(const TaskActionSuccess("Task deleted successfully."));
//       add(GetAllTasksEvent()); // Refresh the task list
//     } catch (e) {
//       emit(TaskError("Failed to delete task: $e"));
//     }
//   }
//
// }
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetAllTasksUseCase getAllTasksUseCase;
  final GetTasksByStatusUseCase getTasksByStatusUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final UpdateTaskStatusUseCase updateTaskStatusUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final GetTasksByDateUseCase getTasksByDateUseCase;
  final FilterTasksUseCase filterTasksUseCase;

  TaskBloc({
    required this.getAllTasksUseCase,
    required this.getTasksByStatusUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.updateTaskStatusUseCase,
    required this.deleteTaskUseCase,
    required this.getTasksByDateUseCase,
    required this.filterTasksUseCase,
  }) : super(TaskInitial()) {
    on<GetAllTasksEvent>(_onGetAllTasks);
    on<GetTasksByStatusEvent>(_onGetTasksByStatus);
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
    try {
      // Optimistically update the state
      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;

        // Find the task and update its status
        final updatedTasks = currentState.tasks.map((task) {
          if (task.id == event.taskId) {
            return task.copyWith(status: event.newStatus);
          }
          return task;
        }).toList();

        emit(TaskLoaded(
          updatedTasks,
          filters: currentState.filters,
        ));
      }

      // Perform the actual update in the repository
      await updateTaskStatusUseCase(event.taskId, event.newStatus);
    } catch (e) {
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
    try {
      await deleteTaskUseCase(event.taskId);
      emit(const TaskActionSuccess("Task deleted successfully."));
    } catch (e) {
      emit(TaskError("Failed to delete task: $e"));
    }
  }
}
