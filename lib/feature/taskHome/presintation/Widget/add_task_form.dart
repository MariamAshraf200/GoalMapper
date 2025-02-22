import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mapperapp/feature/PlanHome/presentation/bloc/bloc.dart';
import 'package:mapperapp/feature/PlanHome/presentation/bloc/event.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_spaces.dart';
import '../../../../core/util/widgets/custom_text_field.dart';
import '../../../../core/util/widgets/date_and_time/date_filed.dart';
import '../../../../core/util/widgets/date_and_time/time_field.dart';
import '../../../../core/util/widgets/loading_elevate_icon_button.dart';
import '../../domain/entity/taskEntity.dart';
import '../bloc/taskBloc/bloc.dart';
import '../bloc/taskBloc/event.dart';
import 'category_selector.dart';
import 'priority_selector.dart';

class AddTaskForm extends StatefulWidget {
  final String? planId; // Make planId optional

  const AddTaskForm({super.key, this.planId});

  @override
  _AddTaskFormState createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescriptionController = TextEditingController();

  DateTime? _taskDate;
  TimeOfDay? _taskStartTime;
  TimeOfDay? _taskEndTime;
  String? _selectedCategory;
  String _selectedPriority = 'Medium';
  bool _allowNotifications = false;

  @override
  void dispose() {
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: AppSpaces.calculatePaddingFromScreenWidth(context),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const SizedBox(height: 10.0),
            CustomTextField(
              isRequired: true,
              outSideTitle: 'Task Title',
              borderRadius: 10,
              labelText: 'Add your task title',
              controller: _taskTitleController,
              maxLength: 42,
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Task title is required';
                }
                return null;
              },
            ),
            CustomTextField(
              outSideTitle: 'Description',
              labelText: 'Add your task description',
              controller: _taskDescriptionController,
              maxLines: 3,
              canBeNull: true,
            ),
            DateFiled(
              onDateSelected: (selectedDate) {
                setState(() {
                  _taskDate = selectedDate;
                });
              },
              isRequired: true,
              outSideTitle: "Task Date",
              labelText: 'dd/mm/yyyy',
              suffixIcon: const Icon(Icons.date_range),
              initialDate: _taskDate,
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TimeField(
                    labelText: "hh:mm AM/PM",
                    outSideTitle: "Task Start Time",
                    onTimeSelected: (selectedTime) {
                      setState(() {
                        _taskStartTime = selectedTime;
                      });
                    },
                    isRequired: true,
                  ),
                ),
                const SizedBox(width: 14.0),
                Expanded(
                  child: TimeField(
                    labelText: "hh:mm AM/PM",
                    outSideTitle: "Task End Time",
                    onTimeSelected: (selectedTime) {
                      setState(() {
                        _taskEndTime = selectedTime;
                      });
                    },
                    isRequired: false,
                    canBeNull: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            CategorySelector(
              onCategorySelected: (selectedCategory) {
                setState(() {
                  _selectedCategory = selectedCategory;
                });
              },
            ),
            const SizedBox(height: 16.0),
            PrioritySelector(
              selectedPriority: _selectedPriority,
              onPrioritySelected: (priority) {
                setState(() {
                  _selectedPriority = priority;
                });
              },
            ),

            // Notifications Switch
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: _allowNotifications,
              onChanged: (value) {
                setState(() {
                  _allowNotifications = value;
                });
              },
            ),

            // Save Button
            LoadingElevatedButton(
              onPressed: _handleSave,
              buttonText: 'Add Task',
              icon: const Icon(Icons.add),
              showLoading: true,
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final formattedDate = DateFormat('dd/MM/yyyy').format(_taskDate!);
    final formattedStartTime = _taskStartTime!.format(context);
    final formattedEndTime = _taskEndTime?.format(context);

    final task = TaskDetails(
      id: const Uuid().v4(),
      title: _taskTitleController.text.trim(),
      description: _taskDescriptionController.text.trim(),
      date: formattedDate,
      time: formattedStartTime,
      endTime: formattedEndTime ?? ' ',
      priority: _selectedPriority,
      category: _selectedCategory ?? 'General',
      status: 'to do',
      planId: widget.planId, // Pass the optional planId
    );

    // Dispatch event with planId
    context.read<TaskBloc>().add(AddTaskEvent(task, planId: widget.planId));
    context.read<PlanBloc>().add(AddTaskToPlanEvent( task: task, planId: widget.planId!));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task added successfully!')),
    );

    Navigator.of(context).pop();
  }

}