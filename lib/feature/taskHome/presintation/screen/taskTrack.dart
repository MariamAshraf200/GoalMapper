import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/widgets/custom_card.dart';
import '../../domain/entity/task_enum.dart';
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

    // Retrieve selected filters from the TaskBloc
    final taskBloc = context.read<TaskBloc>();
    selectedPriority = taskBloc.selectedPriority?.toTaskPriorityString();
    selectedStatus = taskBloc.selectedStatus?.toTaskStatusString();

    // Trigger the filter event with the saved filters
    context.read<TaskBloc>().add(FilterTasksEvent(
      date: selectedDate,
      status: selectedStatus != null ? TaskStatusExtension.fromString(selectedStatus) : null,
      priority: selectedPriority != null ? TaskPriorityExtension.fromString(selectedPriority) : null,
    ));
  }

  void _onDateSelected(DateTime date) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);
    if (formattedDate != selectedDate) {
      setState(() => selectedDate = formattedDate);
      _triggerFilterEvent();
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
        priority: selectedPriority != null ? TaskPriorityExtension.fromString(selectedPriority) : null,
        status: selectedStatus != null ? TaskStatusExtension.fromString(selectedStatus) : null,
      ),
    );
  }

  void _showDatePicker() async {
    final initialDate = DateFormat('dd/MM/yyyy').parse(selectedDate);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != initialDate) {
      setState(() {
        selectedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
      _triggerFilterEvent();
    }
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
              // Title Section with Button and Year
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items to the edges
                children: [
                  // Left side: "My Task" title and year
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, size: 28),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
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
                            icon: const Icon(Icons.date_range_sharp, size: 25),
                            onPressed: _showDatePicker, // Trigger date picker
                          ),
                        ],
                      ),
                      // Display the year of the selected date
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          DateFormat('yyyy/MM/dd').format(DateFormat('dd/MM/yyyy').parse(selectedDate)),
                          style: TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Right side: Add task button
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
              // Date Picker with Selected Date Highlight
              DataFormat(
                selectedDate: selectedDate,
                onDateSelected: _onDateSelected,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withAlpha( 20),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3), // Shadow position
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
                              underline: const SizedBox(), // Remove the underline
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
                  const SizedBox(width: 16), // Adjust spacing between dropdowns
                  // Update the status dropdown to include the new status "Missed"
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withAlpha( 20),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3), // Shadow position
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
                              underline: const SizedBox(), // Remove the underline
                              items: ['Done', 'Pending', 'to do', 'Missed', null]
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
              // Tasks Display Section
              Expanded(
                child: BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    if (state is TaskLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TaskLoaded) {
                      return state.tasks.isEmpty
                          ? const Center(
                        child: Text(
                          "No tasks match the filters.",
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                          : TaskItems(tasks: state.tasks);
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
}
