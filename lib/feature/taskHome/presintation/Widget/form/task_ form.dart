import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../injection_imports.dart';

enum TaskFormMode { add, update }

class TaskForm extends StatefulWidget {
  final TaskFormMode mode;
  final TaskDetails? task;
  final String? planId;
  final void Function(TaskDetails task) onSubmit;

  const TaskForm({
    super.key,
    required this.mode,
    this.task,
    this.planId,
    required this.onSubmit,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  DateTime? _date;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _selectedCategory;
  TaskPriority _selectedPriority = TaskPriority.medium;
  bool _allowNotifications = false;

  @override
  void initState() {
    super.initState();
    if (widget.mode == TaskFormMode.update && widget.task != null) {
      _initializeFromTask(widget.task!);
    } else {
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
    }
  }

  void _initializeFromTask(TaskDetails task) {
    _titleController = TextEditingController(text: task.title);
    _descriptionController = TextEditingController(text: task.description);

    try {
      _date = DateFormat('dd/MM/yyyy').parse(task.date);
    } catch (_) {}

    try {
      final parsedStart = DateFormat('hh:mm a').parse(task.time);
      _startTime = TimeOfDay.fromDateTime(parsedStart);
    } catch (_) {}

    try {
      if (task.endTime.isNotEmpty) {
        final parsedEnd = DateFormat('hh:mm a').parse(task.endTime);
        _endTime = TimeOfDay.fromDateTime(parsedEnd);
      }
    } catch (_) {}

    _selectedCategory = task.category;
    _selectedPriority = TaskPriorityExtension.fromString(task.priority);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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
            const SizedBox(height: 10),
            _buildTitleField(),
            _buildDescriptionField(),
            _buildDateField(),
            const SizedBox(height: 16),
            _buildTimeFields(),
            const SizedBox(height: 16),
            _buildCategorySelector(),
            const SizedBox(height: 16),
            _buildPrioritySelector(),
            _buildNotificationSwitch(),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // ---------------- Widgets ----------------
  Widget _buildTitleField() => CustomTextField(
    isRequired: true,
    outSideTitle: 'Task Title',
    borderRadius: 10,
    labelText: widget.mode == TaskFormMode.add
        ? 'Add your task title'
        : 'Update your task title',
    controller: _titleController,
    maxLength: 42,
    validator: (value) =>
    (value.trim().isEmpty) ? 'Task title is required' : null,
  );

  Widget _buildDescriptionField() => CustomTextField(
    outSideTitle: 'Description',
    labelText: widget.mode == TaskFormMode.add
        ? 'Add your task description'
        : 'Update your task description',
    controller: _descriptionController,
    maxLines: 3,
    canBeNull: true,
  );

  Widget _buildDateField() => DateFiled(
    onDateSelected: (selected) => setState(() => _date = selected),
    isRequired: true,
    outSideTitle: "Task Date",
    labelText: 'dd/mm/yyyy',
    suffixIcon: const Icon(Icons.date_range),
    initialDate: _date,
  );

  Widget _buildTimeFields() => Row(
    children: [
      Expanded(
        child: TimeField(
          labelText: "hh:mm AM/PM",
          outSideTitle: "Task Start Time",
          onTimeSelected: (time) => setState(() => _startTime = time),
          isRequired: true,
          initialTime: _startTime,
        ),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: TimeField(
          labelText: "hh:mm AM/PM",
          outSideTitle: "Task End Time",
          onTimeSelected: (time) => setState(() => _endTime = time),
          isRequired: false,
          canBeNull: true,
          initialTime: _endTime,
        ),
      ),
    ],
  );

  Widget _buildCategorySelector() => CategorySelector(
    onCategorySelected: (category) =>
        setState(() => _selectedCategory = category),
  );

  Widget _buildPrioritySelector() => PrioritySelector(
    selectedPriority: _selectedPriority,
    onPrioritySelected: (priority) =>
        setState(() => _selectedPriority = priority),
  );

  Widget _buildNotificationSwitch() => SwitchListTile(
    title: const Text('Enable Notifications'),
    value: _allowNotifications,
    onChanged: (value) => setState(() => _allowNotifications = value),
  );

  Widget _buildSubmitButton() => LoadingElevatedButton(
    onPressed: _handleSubmit,
    buttonText:
    widget.mode == TaskFormMode.add ? 'Add Task' : 'Update Task',
    icon: Icon(widget.mode == TaskFormMode.add ? Icons.add : Icons.update),
    showLoading: false,
  );

  // ---------------- Logic ----------------
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final task = TaskDetails.fromFormData(
      title: _titleController.text,
      description: _descriptionController.text,
      date: _date,
      startTime: _startTime,
      endTime: _endTime,
      priority: _selectedPriority,
      category: _selectedCategory,
      planId: widget.planId,
      existingTask: widget.task,
      context: context,
    );

    widget.onSubmit(task);
  }
}
