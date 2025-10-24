import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/util/date_and_time/time_range_field.dart';
import '../../../../../injection_imports.dart';
import '../../../../../l10n/l10n_extension.dart';

enum TaskFormMode { add, update }

class TaskForm extends StatefulWidget {
  final TaskFormMode mode;
  final TaskDetails? task;
  final String? planId;

  const TaskForm({
    super.key,
    required this.mode,
    this.task,
    this.planId,
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
      _date = DateFormatUtil.parseDate(task.date);
    } catch (_) {}

    // Robust time parsing for update
    _startTime = null;
    _endTime = null;
    if (task.time.isNotEmpty) {
      try {
        _startTime = TimeFormatUtil.parseTime(task.time);
      } catch (_) {
        // Try parsing as 24-hour format if 12-hour fails
        try {
          final parsed = TimeOfDay(
            hour: int.parse(task.time.split(':')[0]),
            minute: int.parse(task.time.split(':')[1].split(' ')[0]),
          );
          _startTime = parsed;
        } catch (_) {}
      }
    }
    if (task.endTime.isNotEmpty) {
      try {
        _endTime = TimeFormatUtil.parseTime(task.endTime);
      } catch (_) {
        try {
          final parsed = TimeOfDay(
            hour: int.parse(task.endTime.split(':')[0]),
            minute: int.parse(task.endTime.split(':')[1].split(' ')[0]),
          );
          _endTime = parsed;
        } catch (_) {}
      }
    }

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
            const SizedBox(height: 16),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // ---------------- Widgets ----------------
  Widget _buildTitleField() => CustomTextField(
    isRequired: true,
    outSideTitle: context.l10n.taskTitle,
    borderRadius: 10,
    labelText: widget.mode == TaskFormMode.add
        ? context.l10n.addTaskTitle
        : context.l10n.updateTaskTitle,
    controller: _titleController,
    maxLength: 42,
    validator: (value) =>
    (value.trim().isEmpty) ? context.l10n.taskTitleRequired : null,
  );

  Widget _buildDescriptionField() => CustomTextField(
    outSideTitle: context.l10n.description,
    labelText: widget.mode == TaskFormMode.add
        ? context.l10n.addTaskDescription
        : context.l10n.updateTaskDescription,
    controller: _descriptionController,
    maxLines: 3,
    canBeNull: true,
  );

  Widget _buildDateField() => DateFiled(
    onDateSelected: (selected) => setState(() => _date = selected),
    isRequired: true,
    outSideTitle: context.l10n.taskDate,
    labelText: context.l10n.datePlaceholder,
    suffixIcon: const Icon(Icons.date_range),
    initialDate: _date,
  );

  Widget _buildTimeFields() => TimeRangeField(
    startTime: _startTime,
    endTime: _endTime,
    onStartTimeChanged: (time) => setState(() => _startTime = time),
    onEndTimeChanged: (time) => setState(() => _endTime = time),
    canBeNull: true,
  );


  Widget _buildCategorySelector() => BlocBuilder<CategoryBloc, CategoryState>(
    builder: (context, state) {
      // Use the core logic widget which handles loading, add and delete through the Bloc
      return CategorySelectorWithLogic(
        selectedCategory: _selectedCategory,
        onCategorySelected: (category) => setState(() => _selectedCategory = category),
      );
    },
  );

  Widget _buildPrioritySelector() => PrioritySelectorWithLogic(
    selectedPriority: _selectedPriority,
    onPrioritySelected: (p) => setState(() => _selectedPriority = p),
  );


  Widget _buildSubmitButton() => LoadingElevatedButton(
    onPressed: _handleSubmit,
    buttonText:
    widget.mode == TaskFormMode.add ? context.l10n.addTaskButton : context.l10n.updateTaskButton,
    icon: Icon(widget.mode == TaskFormMode.add ? Icons.add : Icons.update),
    showLoading: false,
  );

  // ---------------- Logic ----------------
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    // Use existing time if not changed in update mode
    TimeOfDay? startTime = _startTime;
    TimeOfDay? endTime = _endTime;
    if (widget.mode == TaskFormMode.update && widget.task != null) {
      if (startTime == null) {
        try {
          startTime = TimeFormatUtil.parseTime(widget.task!.time);
        } catch (_) {}
      }
      if (endTime == null) {
        try {
          if (widget.task!.endTime.isNotEmpty) {
            endTime = TimeFormatUtil.parseTime(widget.task!.endTime);
          }
        } catch (_) {}
      }
    }

    final task = TaskDetails.fromFormData(
      title: _titleController.text,
      description: _descriptionController.text,
      date: _date,
      startTime: startTime,
      endTime: endTime,
      priority: _selectedPriority,
      category: _selectedCategory,
      planId: widget.planId,
      existingTask: widget.task,
      context: context,
    );

    if (widget.mode == TaskFormMode.add) {
      context.read<TaskBloc>().add(AddTaskEvent(task, planId: widget.planId));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.taskAdded)));
    } else {
      context.read<TaskBloc>().add(UpdateTaskEvent(task));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.taskUpdated)));
    }

    Navigator.of(context).pop();
  }
}
