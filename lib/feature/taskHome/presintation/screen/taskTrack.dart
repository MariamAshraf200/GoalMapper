import '../../../../../injection_imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/taskBloc/state.dart' as taskState;
import 'package:mapperapp/l10n/l10n_extension.dart';
import '../Widget/header/task_header.dart';

class TaskTrack extends StatefulWidget {
  const TaskTrack({super.key});

  @override
  State<TaskTrack> createState() => _TaskTrackState();
}

class _TaskTrackState extends State<TaskTrack> {
  late String selectedDate;
  String? selectedPriority;
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedDate = DateFormatUtil.getCurrentDateFormatted();

    final taskBloc = context.read<TaskBloc>();
    selectedPriority = taskBloc.selectedPriority?.toTaskPriorityString();
    selectedStatus = taskBloc.selectedStatus?.toTaskStatusString();

    _triggerFilterEvent();
  }

  void _triggerFilterEvent() {
    context.read<TaskBloc>().add(
          FilterTasksEvent(
            date: selectedDate,
            priority: selectedPriority != null
                ? TaskPriorityExtension.fromString(selectedPriority)
                : null,
            status: selectedStatus != null
                ? TaskStatusExtension.fromString(selectedStatus)
                : null,
          ),
        );
  }

  void _updateDate(String newDate) {
    setState(() => selectedDate = newDate);
    _triggerFilterEvent();
  }

  void _updatePriority(String? priority) {
    setState(() => selectedPriority = priority);
    _triggerFilterEvent();
  }

  void _updateStatus(String? status) {
    setState(() => selectedStatus = status);
    _triggerFilterEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomCard(
        margin: const EdgeInsets.symmetric(vertical: 0.0),
        padding: const EdgeInsets.all(8),
        elevation: 0.0,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            TaskHeader(
              selectedDate: selectedDate,
              onDatePicked: _updateDate,
            ),
            const SizedBox(height: 10),
            TaskDateSelector(
              selectedDate: selectedDate,
              onDateSelected: _updateDate,
            ),
            const SizedBox(height: 16),
            TaskFilters(
              selectedPriority: selectedPriority,
              selectedStatus: selectedStatus,
              onPriorityChanged: _updatePriority,
              onStatusChanged: _updateStatus,
            ),
            const SizedBox(height: 16),
            const TaskListSection(),
          ],
        ),
      ),
    );
  }
}

class TaskDateSelector extends StatelessWidget {
  final String selectedDate;
  final ValueChanged<String> onDateSelected; // changed to String

  const TaskDateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DataFormat(
      selectedDate: selectedDate,
      onDateSelected: (date) {
        // format DateTime → String before passing back
        final formatted = DateFormatUtil.formatDate(date);
        onDateSelected(formatted);
      },
    );
  }
}

class TaskFilters extends StatelessWidget {
  final String? selectedPriority;
  final String? selectedStatus;
  final ValueChanged<String?> onPriorityChanged;
  final ValueChanged<String?> onStatusChanged;

  const TaskFilters({
    super.key,
    required this.selectedPriority,
    required this.selectedStatus,
    required this.onPriorityChanged,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FilterDropdown<String>(
            icon: const Icon(Icons.filter_list, color: Colors.blue),
            value: selectedPriority,
            hint: context.l10n.selectPriority,
            items: [
              ...TaskPriority.values.map((p) => DropdownMenuItem(
                  value: p.toTaskPriorityString(),
                  child: Text(p.toPriorityLabel(context)))),
              DropdownMenuItem(
                  value: null, child: Text(context.l10n.allPriorities)),
            ],
            onChanged: onPriorityChanged,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _FilterDropdown<String>(
            icon: const Icon(Icons.task_alt, color: Colors.green),
            value: selectedStatus,
            hint: context.l10n.selectStatus,
            items: [
              ...TaskStatus.values.map((s) => DropdownMenuItem(
                  value: s.toTaskStatusString(),
                  child: Text(s.localized(context)))),
              DropdownMenuItem(
                  value: null, child: Text(context.l10n.allStatuses)),
            ],
            onChanged: onStatusChanged,
          ),
        ),
      ],
    );
  }
}

class _FilterDropdown<T> extends StatelessWidget {
  final Widget icon;
  final T? value;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _FilterDropdown({
    required this.icon,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withAlpha(20), blurRadius: 5)],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<T>(
              value: value,
              hint: Text(hint,
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
              isExpanded: true,
              underline: const SizedBox(),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class TaskListSection extends StatelessWidget {
  const TaskListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<TaskBloc, taskState.TaskState>(
        builder: (context, state) {
          if (state is taskState.TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is taskState.TaskLoaded) {
            if (state.tasks.isEmpty) {
              return Center(
                  child: Text(context.l10n.noTasksMatchFilters,
                      style: const TextStyle(fontSize: 18)));
            }
            return TaskItems(tasks: state.tasks);
          } else if (state is taskState.TaskError) {
            return Center(
                child:
                    Text(state.message, style: const TextStyle(fontSize: 18)));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
