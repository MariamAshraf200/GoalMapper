import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/customColor.dart';
import '../../domain/entity/taskEntity.dart';
import '../Widget/customTextFeild.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';

class AddTaskAndUpdateScreen extends StatefulWidget {
  final TaskEntity? existingTask;

  const AddTaskAndUpdateScreen({super.key, this.existingTask});

  @override
  _AddTaskAndUpdateScreenState createState() => _AddTaskAndUpdateScreenState();
}

class _AddTaskAndUpdateScreenState extends State<AddTaskAndUpdateScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String selectedPriority = '';
  late String uniqueTaskId;
  CustomColor color = CustomColor();
  bool allowNotifications = false;

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
      categoryController.text = widget.existingTask!.category;
    } else {
      uniqueTaskId = const Uuid().v4();
    }
  }

  // Bottom sheet to allow user to enter or select category
  void _showCategoryBottomSheet() {
    categoryController.text = widget.existingTask?.category ?? '';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // TextField to allow user to enter a custom category
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  hintText: 'Enter category',
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  if (categoryController.text.isNotEmpty) {
                    setState(() {
                      categoryController.text = categoryController.text;
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Category'),
              ),
            ],
          ),
        );
      },
    );
  }

  String? _validateTextField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
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

                // Title TextField
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: "Add task title",
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),

                // Description TextField
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'Description',
                  description: true,
                  validator: _validateTextField,
                  readOnly: false,
                ),

                // Category TextField with bottom sheet interaction
                CustomTextField(
                  controller: categoryController,
                  hintText: 'Select or Enter Category',
                  suffixIcon: const Icon(Icons.category),
                  onTap: _showCategoryBottomSheet,
                  readOnly: false,
                  validator: _validateTextField,
                ),

                // Date and Time Inputs
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
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
                        readOnly: false,
                      ),
                    ),
                    Expanded(
                      child: CustomTextField(
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
                        readOnly: false,
                      ),
                    ),
                  ],
                ),

                // Switch for Notifications
                SwitchListTile(
                  title: const Text("Enable Notifications"),
                  value: allowNotifications,
                  onChanged: (bool value) {
                    setState(() {
                      allowNotifications = value;
                    });
                  },
                ),

                // Save or Update Task Button
                ElevatedButton(
                  onPressed: () {
                    final task = TaskEntity(
                      title: titleController.text,
                      description: descriptionController.text,
                      date: dateController.text,
                      time: timeController.text,
                      priority: selectedPriority,
                      category: categoryController.text,
                      id: uniqueTaskId,
                      status: 'to do',
                    );

                    if (widget.existingTask != null) {
                      context.read<TaskBloc>().add(UpdateTaskEvent(task));
                    } else {
                      context.read<TaskBloc>().add(AddTaskEvent(task));
                    }
                  },
                  child: Text(widget.existingTask != null ? 'Update Task' : 'Save Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
