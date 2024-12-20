import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spaces.dart';
import '../../../../core/customColor.dart';
import '../../../../core/util/widgets/custom_card.dart';
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
  // CustomColor color = CustomColor();

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
      body: CustomCard(
        margin: const EdgeInsets.symmetric(vertical: 0.0),
        padding:
        //AppSpaces.calculatePaddingFromScreenWidth(context),
        const EdgeInsets.all(15),
        elevation: 0.0,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0,horizontal: 4.0),
          child: Column(
            children: [
              // Title Section with Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'My Task',
                      style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.secondaryColor, width: 2),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddTaskAndUpdateScreen(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.add,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height:20),
              DataFormat(
                selectedDate: selectedDate,
                onDateSelected: _onDateSelected,
              ),
              const SizedBox(height: 16),
              // Tasks Display Section
              SizedBox(
                height: 600,
                width: 400,
                child: BlocBuilder<TaskBloc, TaskState>(
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
                          : ListView.builder(

                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tasksForSelectedDate.length,
                        itemBuilder: (context, index) {
                          final task = tasksForSelectedDate[index];
                          return TaskCard(
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Failed to update task status: $e")),
                                );
                              }
                            },
                          );
                        },
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
