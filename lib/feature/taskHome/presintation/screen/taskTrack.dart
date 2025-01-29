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
  String? selectedPriority;
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    // Initial filter event trigger
    context.read<TaskBloc>().add(FilterTasksEvent(
      date: selectedDate,
      status: selectedStatus,
      priority: selectedPriority,
    ));
  }

  // Handle date selection and update state
  void _onDateSelected(DateTime date) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);
    if (formattedDate != selectedDate) {
      setState(() => selectedDate = formattedDate);
      context.read<TaskBloc>().add(FilterTasksEvent(
        date: selectedDate,
        status: selectedStatus,
        priority: selectedPriority,
      ));
    }
  }

  // Show date picker and update date
  void _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateFormat('dd/MM/yyyy').parse(selectedDate),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      _onDateSelected(pickedDate);
    }
  }

  void _onPrioritySelected(String? priority) {
    setState(() => selectedPriority = priority);
    _triggerFilterEvent();
  }

  void _onStatusSelected(String? status) {
    setState(() => selectedStatus = status);
    _triggerFilterEvent();
  }

  void _triggerFilterEvent() {
    context.read<TaskBloc>().add(
      FilterTasksEvent(
        date: selectedDate,
        priority: selectedPriority,
        status: selectedStatus,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomCard(
        margin: const EdgeInsets.symmetric(vertical: 0.0),
        padding: const EdgeInsets.all(8),
        elevation: 0.0,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 4.0),
          child: Column(
            children: [
              // Title Section with Date Picker Icon
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
                        const SizedBox(width: 5),
                        IconButton(
                          onPressed: _pickDate,
                          icon: const Icon(Icons.date_range_sharp, size: 25),
                        ),
                      ],
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
                            builder: (context) => const AddTaskScreen(),
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

              // Date Display Section
              DataFormat(
                selectedDate: selectedDate,
                onDateSelected: _onDateSelected,
              ),
              const SizedBox(height: 16),

              // Filter Options (Priority and Status)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.filter_list, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButton<String>(
                              value: selectedPriority,
                              hint: const Text(
                                "Select Priority",
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              isExpanded: true,
                              underline: const SizedBox(),
                              items: ['High', 'Medium', 'Low', null]
                                  .map((priority) => DropdownMenuItem<String>(
                                value: priority,
                                child: Text(priority ?? "All Priorities"),
                              ))
                                  .toList(),
                              onChanged: _onPrioritySelected,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.task_alt, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButton<String>(
                              value: selectedStatus,
                              hint: const Text(
                                "Select Status",
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              isExpanded: true,
                              underline: const SizedBox(),
                              items: ['Done', 'Pending', 'to do', null]
                                  .map((status) => DropdownMenuItem<String>(
                                value: status,
                                child: Text(status ?? "All Statuses"),
                              ))
                                  .toList(),
                              onChanged: _onStatusSelected,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Task Display Section
              Expanded(
                child: BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    if (state is TaskLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TaskLoaded) {
                      return state.tasks.isEmpty
                          ? const Center(child: Text("No tasks match the filters."))
                          : TaskItems(tasks: state.tasks);
                    } else if (state is TaskError) {
                      return Center(child: Text(state.message));
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
}
