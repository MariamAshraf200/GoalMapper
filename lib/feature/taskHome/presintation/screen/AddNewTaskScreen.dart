import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mapper_app/feature/taskHome/presintation/screen/todoScreen.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entity/taskEntity.dart';
import '../Widget/customContainerAddnewTask.dart';
import '../Widget/customTextFeild.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskEntity? existingTask;

  const AddTaskScreen({super.key, this.existingTask});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String selectedPriority = '';
  late String uniqueTaskId;

  @override
  void initState() {
    super.initState();
    if (widget.existingTask != null) {
      titleController.text = widget.existingTask!.title;
      descriptionController.text = widget.existingTask!.description;
      dateController.text = widget.existingTask!.date;
      timeController.text = widget.existingTask!.time;
      selectedPriority = widget.existingTask!.priority;
      uniqueTaskId = widget.existingTask!.id;
    } else {
      uniqueTaskId = const Uuid().v4();
    }
  }

  String? _validateTextField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  void togglePriority(String priority) {
    setState(() {
      selectedPriority = priority;
    });
  }

  // Method to return color based on priority
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50))),
        backgroundColor: Colors.deepPurple,
        title: const Center(
          child: Text(
            'Task Manager',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskAddSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task saved successfully!')),
          );
          Navigator.pop(context, state.task);
        } else if (state is TaskError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        } else if (state is TaskActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task updated successfully!')),
          );
          Navigator.pop(context);
        }
      },
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(
                  controller: titleController,
                  hintText: 'Add title of task',
                  title: 'Task Title',
                  validator: _validateTextField,
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'Description',
                  description: true,
                  title: 'Description',
                  validator: _validateTextField,
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  controller: dateController,
                  hintText: 'dd/mm/yyyy',
                  title: 'Date',
                  suffixIcon: const Icon(Icons.date_range),
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      dateController.text =
                          DateFormat('dd/MM/yyyy').format(selectedDate);
                    }
                  },
                  validator: _validateTextField,
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  controller: timeController,
                  hintText: 'hh:mm AM/PM',
                  title: 'Time',
                  suffixIcon: const Icon(Icons.access_time),
                  onTap: () async {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      final now = DateTime.now();
                      final selectedDateTime = DateTime(
                        now.year,
                        now.month,
                        now.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                      timeController.text =
                          DateFormat('hh:mm a').format(selectedDateTime);
                    }
                  },
                  validator: _validateTextField,
                ),
                const SizedBox(height: 16.0),
                // Priority Selector with color changes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['Low', 'Medium', 'High'].map((priority) {
                    return CustomContainerNewTask(
                      text: priority,
                      backgroundColor: selectedPriority == priority
                          ? _getPriorityColor(priority)
                          : Colors.grey,
                      borderRadius: 25,
                      textStyle: TextStyle(
                        color: selectedPriority == priority
                            ? Colors.white
                            : Colors.black,
                      ),
                      onTap: () => togglePriority(priority),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final task = TaskEntity(
                        title: titleController.text,
                        description: descriptionController.text,
                        date: dateController.text,
                        time: timeController.text,
                        priority: selectedPriority,
                        id: uniqueTaskId,
                        status: 'to do',
                      );

                      if (widget.existingTask != null) {
                        context.read<TaskBloc>().add(UpdateTaskEvent(task));
                      } else {
                        context.read<TaskBloc>().add(AddTaskEvent(task));
                      }

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TaskListScreen(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    widget.existingTask != null ? 'Update Task' : 'Save Task',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
