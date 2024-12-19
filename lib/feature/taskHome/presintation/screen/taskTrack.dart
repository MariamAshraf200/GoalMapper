import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/customColor.dart';
import '../Widget/customContainerTask.dart';
import '../Widget/data_format.dart';
import '../bloc/bloc.dart';
import '../bloc/state.dart';
import '../bloc/event.dart';
import 'AddNewAndUpdateTaskScreen.dart';

class TaskTrack extends StatefulWidget {
   const TaskTrack({super.key});
  @override
  _TaskTrackState createState() => _TaskTrackState();
}

class _TaskTrackState extends State<TaskTrack> {
  late String selectedDate;
  CustomColor color = CustomColor();

  @override
  void initState() {
    super.initState();
    selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    context.read<TaskBloc>().add(GetTasksByDateEvent(selectedDate));
  }

  void _onDateSelected(DateTime date) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);
    setState(() {
      selectedDate = formattedDate;
    });
    context.read<TaskBloc>().add(GetTasksByDateEvent(formattedDate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'My Tasks',
                      style: TextStyle(color: color.secondaryColor, fontSize: 30),
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
                      icon: Icon(Icons.add, color: color.secondaryColor),
                    ),
                  ),
                ],
              ),

              DataFormat(
                selectedDate: selectedDate,
                onDateSelected: _onDateSelected,
              ),

              // Tasks Display
              BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state is TaskLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TaskLoaded) {
                    final tasksForSelectedDate = state.tasks.where((task) {
                      DateTime taskDate = _parseTaskDate(task.date);
                      return _isSameDay(taskDate, _parseTaskDate(selectedDate));
                    }).toList();

                    return tasksForSelectedDate.isEmpty
                        ? const Center(
                      child: Text(
                        "No tasks for this date.",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "You have ${tasksForSelectedDate.length} task.",
                          style: const TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...tasksForSelectedDate.map(
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
                            },// category: task.category,
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

  DateTime _parseTaskDate(String dateString) {
    try {
      return DateFormat('dd/MM/yyyy').parseStrict(dateString);
    } catch (e) {
      return DateTime.now();
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
