import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../Widget/customContainerTask.dart';
import '../Widget/data_format.dart';
import '../bloc/bloc.dart'; // Assuming this includes the TaskBloc
import '../bloc/state.dart'; // Assuming this includes TaskState
import '../bloc/event.dart';
import 'AddNewAndUpdateTaskScreen.dart'; // Assuming this includes TaskEvent

class TaskTrack extends StatelessWidget {
  const TaskTrack({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    // Fetch all tasks on initial build with current date
    context.read<TaskBloc>().add(GetTasksByDateEvent(currentDate));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Tracker'),
        backgroundColor: Colors.teal[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Title and Add Task button
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'My Tasks',
                      style: TextStyle(color: Colors.teal[400], fontSize: 30),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddTaskAndUpdateScreen(),
                          ),
                        );
                      },
                      icon: Icon(Icons.add, color: Colors.teal[400]),
                    ),
                  ),
                ],
              ),

              const DataFormat(),

              BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state is TaskLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TaskLoaded) {
                    final today = DateTime.now(); // Get today's date
                    final tasksForToday = state.tasks.where((task) {
                      DateTime taskDate = _parseTaskDate(task.date);
                      return _isSameDay(taskDate, today);
                    }).toList();

                    return tasksForToday.isEmpty
                        ? const Center(
                      child: Text(
                        "No tasks for today.",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                        : Column(
                      children: [
                        Text(
                          "You have ${tasksForToday.length} task(s) today",
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...tasksForToday.map(
                              (task) => TaskCard(
                            title: task.title,
                            description: task.description,
                            date: task.date,
                            time: task.time,
                            priority: task.priority,
                            taskId: task.id,
                            status: task.status,
                            onViewClicked: () async {
                              try {
                                context.read<TaskBloc>().add(
                                  UpdateTaskStatusEvent(
                                    task.id,
                                    'done',
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Failed to update task status: $e",
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  } else if (state is TaskError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to safely parse task date string
  DateTime _parseTaskDate(String dateString) {
    try {
      // Try parsing the task date based on the format 'dd/MM/yyyy'
      return DateFormat('dd/MM/yyyy').parseStrict(dateString);
    } catch (e) {
      // Return a default date if parsing fails
      return DateTime.now();
    }
  }

  // Helper method to check if two dates are on the same day (ignores time)
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
