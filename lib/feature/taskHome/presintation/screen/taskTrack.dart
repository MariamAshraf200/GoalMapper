import '../../../../../injection_imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
class TaskHeader extends StatelessWidget {
  final String selectedDate;
  final ValueChanged<String> onDatePicked;

  const TaskHeader({
    super.key,
    required this.selectedDate,
    required this.onDatePicked,
  });

  void _showDatePicker(BuildContext context) async {
    final initialDate = DateFormatUtil.parseDate(selectedDate);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      onDatePicked(DateFormatUtil.formatDate(pickedDate));
    }
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
      ),
      child: IconButton(
        icon: Icon(icon, size: 22, color: Colors.black87),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button with circle border
          _circleIconButton(
            icon: Icons.arrow_back_ios_new,
            onPressed: () => Navigator.of(context).pop(),
          ),

          // Centered full date
          GestureDetector(
            onTap: () => _showDatePicker(context),
            child: Text(
              DateFormatUtil.formatFullDate(selectedDate), // e.g. April 20, 2024
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Add button with circle border
          _circleIconButton(
            icon: Icons.add,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddTaskScreen()),
              );
            },
          ),
        ],
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
            hint: "Select Priority",
            items: [
              ...TaskPriority.values.map((p) =>
                  DropdownMenuItem(value: p.toTaskPriorityString(), child: Text(p.toTaskPriorityString()))),
              const DropdownMenuItem(value: null, child: Text("All Priorities")),
            ],
            onChanged: onPriorityChanged,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _FilterDropdown<String>(
            icon: const Icon(Icons.task_alt, color: Colors.green),
            value: selectedStatus,
            hint: "Select Status",
            items: [
              ...TaskStatus.values.map((s) =>
                  DropdownMenuItem(value: s.toTaskStatusString(), child: Text(s.toTaskStatusString()))),
              const DropdownMenuItem(value: null, child: Text("All Statuses")),
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
              hint: Text(hint, style: const TextStyle(fontSize: 14, color: Colors.grey)),
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
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            if (state.tasks.isEmpty) {
              return const Center(child: Text("No tasks match the filters.", style: TextStyle(fontSize: 18)));
            }
            return TaskItems(tasks: state.tasks);
          } else if (state is TaskError) {
            return Center(child: Text(state.message, style: const TextStyle(fontSize: 18)));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
