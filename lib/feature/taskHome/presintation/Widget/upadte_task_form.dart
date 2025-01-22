import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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

class UpdateTaskForm extends StatefulWidget {
  final TaskDetails task;

  const UpdateTaskForm({Key? key, required this.task}) : super(key: key);

  @override
  _UpdateTaskFormState createState() => _UpdateTaskFormState();
}

class _UpdateTaskFormState extends State<UpdateTaskForm>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _taskTitleController;
  late final TextEditingController _taskDescriptionController;

  DateTime? _taskDate;
  TimeOfDay? _taskStartTime;
  TimeOfDay? _taskEndTime;
  String? _selectedCategory;
  String _selectedPriority = 'Medium';
  bool _allowNotifications = false;

  @override
  void initState() {
    super.initState();
    _initializeFormFields();
  }

  void _initializeFormFields() {
    _taskTitleController = TextEditingController(text: widget.task.title);
    _taskDescriptionController =
        TextEditingController(text: widget.task.description);
    _taskDate = _tryParseDate(widget.task.date);
    _taskStartTime = _tryParseTime(widget.task.time);
    _taskEndTime = widget.task.endTime.isNotEmpty == true
        ? _tryParseTime(widget.task.endTime)
        : null;
    _selectedCategory = widget.task.category;
    _selectedPriority = widget.task.priority;
  }

  DateTime? _tryParseDate(String? date) {
    if (date == null || date.isEmpty) return null;
    try {
      return DateFormat('dd/MM/yyyy').parse(date);
    } catch (e) {
      debugPrint('Error parsing date: $e');
      return null;
    }
  }

  TimeOfDay? _tryParseTime(String? time) {
    if (time == null || time.isEmpty) return null;
    try {
      final parsed = DateFormat.jm().parse(time);
      return TimeOfDay.fromDateTime(parsed);
    } catch (e) {
      debugPrint('Error parsing time: $e');
      return null;
    }
  }

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
            _buildTitleField(),
            _buildDescriptionField(),
            _buildDateField(),
            const SizedBox(height: 16.0),
            _buildTimeFields(),
            const SizedBox(height: 16.0),
            _buildCategorySelector(),
            const SizedBox(height: 16.0),
            _buildPrioritySelector(),
            _buildNotificationSwitch(),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return CustomTextField(
      isRequired: true,
      outSideTitle: 'Task Title',
      borderRadius: 10,
      labelText: 'Update your task title',
      controller: _taskTitleController,
      maxLength: 42,
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'Task title is required';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return CustomTextField(
      outSideTitle: 'Description',
      labelText: 'Update your task description',
      controller: _taskDescriptionController,
      maxLines: 3,
      canBeNull: true,
    );
  }

  Widget _buildDateField() {
    return DateFiled(
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
    );
  }

  Widget _buildTimeFields() {
    return Row(
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
            initialTime: _taskStartTime,
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
            initialTime: _taskEndTime,
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return CategorySelector(
      onCategorySelected: (selectedCategory) {
        setState(() {
          _selectedCategory = selectedCategory;
        });
      },
    );
  }

  Widget _buildPrioritySelector() {
    return PrioritySelector(
      selectedPriority: _selectedPriority,
      onPrioritySelected: (priority) {
        setState(() {
          _selectedPriority = priority;
        });
      },
    );
  }

  Widget _buildNotificationSwitch() {
    return SwitchListTile(
      title: const Text('Enable Notifications'),
      value: _allowNotifications,
      onChanged: (value) {
        setState(() {
          _allowNotifications = value;
        });
      },
    );
  }

  Widget _buildSaveButton() {
    return LoadingElevatedButton(
      onPressed: _handleUpdate,
      buttonText: 'Update Task',
      icon: const Icon(Icons.update),
      showLoading: true,
    );
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final formattedDate = _taskDate != null
        ? DateFormat('dd/MM/yyyy').format(_taskDate!)
        : '';
    final formattedStartTime = _taskStartTime?.format(context) ?? '';
    final formattedEndTime = _taskEndTime?.format(context) ?? '';

    final updatedTask = widget.task.copyWith(
      title: _taskTitleController.text.trim(),
      description: _taskDescriptionController.text.trim(),
      date: formattedDate,
      time: formattedStartTime,
      endTime: formattedEndTime,
      priority: _selectedPriority,
      category: _selectedCategory ?? 'General',
    );

    context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task updated successfully!')),
    );

    Navigator.of(context).pop();
  }
}
