import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mapper_app/feature/taskHome/presintation/screen/todoScreen.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/customColor.dart';
import '../../domain/entity/taskEntity.dart';
import '../Widget/customContainerAddnewTask.dart';
import '../Widget/customTextFeild.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';

class AddTaskAndUpdateScreen extends StatefulWidget {
  final TaskDetails? existingTask;

  const AddTaskAndUpdateScreen({super.key, this.existingTask});

  @override
  _AddTaskAndUpdateScreenState createState() => _AddTaskAndUpdateScreenState();
}

class _AddTaskAndUpdateScreenState extends State<AddTaskAndUpdateScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String selectedPriority = '';
  String selectedCategory = '';
  late String uniqueTaskId;
  CustomColor color = CustomColor();
  bool allowNotifications = false;

  final List<String> categories = [
    'Work',
    'Personal',
    'Shopping',
    'Fitness',
    'Other'
  ]; // List of categories

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

  Color _getPriorityColor(String priority) {
    return selectedPriority == priority ? Colors.deepPurple : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Manage your Task',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25)),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: "Add task title",
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
                Column(
                  children: [
                    CustomTextField(
                      controller: descriptionController,
                      hintText: 'Description',
                      description: true,
                      validator: _validateTextField,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.record_voice_over_sharp),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.text_fields),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.person_add),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text('Date'),
                          CustomTextField(
                            controller: dateController,
                            hintText: 'dd/mm/yyyy',
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
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text('Time'),
                          CustomTextField(
                            controller: timeController,
                            hintText: 'hh:mm AM/PM',
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
                        ],
                      ),
                    ),
                  ],
                ),

                // Category Dropdown
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory.isNotEmpty ? selectedCategory : null,
                    hint: const Text('Select Category'),
                    items: categories
                        .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Please select a category' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ['Low', 'Medium', 'High'].map((priority) {
                      return CustomContainerNewTask(
                        text: priority,
                        backgroundColor: _getPriorityColor(priority),
                        borderRadius: 25,
                        textStyle: TextStyle(
                          color: selectedPriority == priority
                              ? color.basicColor
                              : color.primaryColor,
                        ),
                        onTap: () => togglePriority(priority),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Expanded(child: Text('Allow Alert')),
                      Switch(
                        value: allowNotifications,
                        onChanged: (value) {
                          setState(() {
                            allowNotifications = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final task = TaskDetails(
                            title: titleController.text,
                            description: descriptionController.text,
                            date: dateController.text,
                            time: timeController.text,
                            priority: selectedPriority,
                            //category: selectedCategory,
                            id: uniqueTaskId,
                            status: 'to do',
                          );

                          if (widget.existingTask != null) {
                            context.read<TaskBloc>().add(UpdateTaskEvent(task));
                          } else {
                            context.read<TaskBloc>().add(AddTaskEvent(task));
                          }
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const TaskListScreen(),
                          //   ),
                          // );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        widget.existingTask != null ? 'Update Task' : 'Save Task',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
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
