import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/widgets/custom_card.dart';
import '../Widget/data_format.dart';
import '../Widget/task_items.dart';
import '../bloc/taskBloc/bloc.dart';
import '../bloc/taskBloc/event.dart';
import '../bloc/taskBloc/state.dart';
import 'add_task_screen.dart';

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
            const EdgeInsets.all(8),
        elevation: 0.0,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 4.0),
          child: Column(
            children: [
              // Title Section with Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          ' My Task',
                          style: TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5,),
                        const Icon(Icons.date_range_sharp,size: 25,)
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: AppColors.secondaryColor, width: 2),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                             const AddTaskScreen()
                              //  const AddTaskAndUpdateScreen(),
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
              const SizedBox(height: 20),
              DataFormat(
                selectedDate: selectedDate,
                onDateSelected: _onDateSelected,
              ),
              const SizedBox(height: 16),
              // Tasks Display Section
              Expanded(
                child:BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    if (state is TaskLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TaskLoaded) {
                      final tasksForSelectedDate = state.tasks.where((task) {
                        DateTime taskDate = _parseTaskDate(task.date);
                        return _isSameDay(
                            taskDate, _parseTaskDate(selectedDate));
                      }).toList();

                      return tasksForSelectedDate.isEmpty
                          ? const Center(
                        child: Text(
                          "No tasks for this date.",
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                          : TaskItems(
                        tasks: tasksForSelectedDate,
                      );
                    } else if (state is TaskAddSuccess) {
                      // Refresh tasks on success
                      context
                          .read<TaskBloc>()
                          .add(GetTasksByDateEvent(selectedDate));
                      return const SizedBox(); // Placeholder while tasks refresh
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

                // BlocBuilder<TaskBloc, TaskState>(
                //   builder: (context, state) {
                //     if (state is TaskLoading) {
                //       return const Center(child: CircularProgressIndicator());
                //     } else if (state is TaskLoaded) {
                //       final tasksForSelectedDate = state.tasks.where((task) {
                //         DateTime taskDate = _parseTaskDate(task.date);
                //         return _isSameDay(
                //             taskDate, _parseTaskDate(selectedDate));
                //       }).toList();
                //
                //       return tasksForSelectedDate.isEmpty
                //           ? const Center(
                //               child: Text(
                //                 "No tasks for this date.",
                //                 style: TextStyle(fontSize: 18),
                //               ),
                //             )
                //           : TaskItems(
                //         tasks: tasksForSelectedDate,
                //       );
                //     } else if (state is TaskError) {
                //       return Center(
                //         child: Text(
                //           state.message,
                //           style: const TextStyle(fontSize: 18),
                //         ),
                //       );
                //     }
                //     return const SizedBox();
                //   },
                // ),
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
