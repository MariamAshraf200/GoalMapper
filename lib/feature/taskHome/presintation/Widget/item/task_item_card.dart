import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../../injection_imports.dart';


class TaskItemCard extends StatelessWidget {
  final TaskDetails task;

  const TaskItemCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    // Automatically mark missed if needed
    if (task.shouldBeMissed(DateTime.now())) {
      context.read<TaskBloc>().add(
        UpdateTaskStatusEvent(
          task.id,
          TaskStatus.missed,
          updatedTime: DateFormat('hh:mm a').format(DateTime.now()),
        ),
      );
    }

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.horizontal,
      background: _buildEditBackground(),
      secondaryBackground: _buildDeleteBackground(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _showUpdateDialog(context, task);
        } else {
          _showDeleteDialog(context, task);
        }
        return false;
      },
      child: _buildContent(context),
    );
  }

  Widget _buildEditBackground() => Container(
    color: Colors.blue,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: const Icon(Icons.edit, color: Colors.white),
  );

  Widget _buildDeleteBackground() => Container(
    color: Colors.red,
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: const Icon(Icons.delete, color: Colors.white),
  );

  Widget _buildContent(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _handleLongPress(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TaskTimeColumn(task: task),
          const SizedBox(width: 8),
          Expanded(
            child: CustomCard(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(12),
              borderRadius: BorderRadius.circular(15),
              elevation: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoSection(),
                  _buildStatusIcon(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPriorityLabel(),
        const SizedBox(height: 8),
        Text(
          task.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          task.description,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );

  Widget _buildPriorityLabel() => Container(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    decoration: BoxDecoration(
      color: task.priority.toPriorityColor(),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      task.priority,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _buildStatusIcon(BuildContext context) {
    return GestureDetector(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, anim) =>
            ScaleTransition(scale: anim, child: child),
        child: _statusIcon(),
      ),
      onTap: () => _toggleStatus(context),
    );
  }

  Widget _statusIcon() {
    if (task.isCompleted) {
      return SvgPicture.asset(AppAssets.rightCheckBox,
          width: 30, height: 30, key: const ValueKey('completed'));
    } else if (task.isMissed) {
      return Image.asset('assets/images/missid.png',
          width: 30, height: 30, key: const ValueKey('missed'));
    } else if (task.isPending) {
      return Image.asset('assets/images/pending-clock-icon.webp',
          width: 30, height: 30, key: const ValueKey('pending'));
    }
    return Container(
      key: const ValueKey('notCompleted'),
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey, width: 2),
      ),
    );
  }

  // ----------------- Event handlers -----------------
  void _toggleStatus(BuildContext context) {
    if (task.isMissed) return _showErrorDialog(context);

    final newStatus = task.isCompleted ? TaskStatus.pending : TaskStatus.done;

    context.read<TaskBloc>().add(UpdateTaskStatusEvent(
      task.id,
      newStatus,
      updatedTime: DateFormat('hh:mm a').format(DateTime.now()),
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task marked as ${newStatus.toTaskStatusString()}'),
        duration: const Duration(seconds: 1),
        backgroundColor: newStatus == TaskStatus.done ? Colors.green : Colors.orange,
      ),
    );
  }

  void _handleLongPress(BuildContext context) {
    if (task.isCompleted || task.isMissed) {
      _showErrorDialog(context);
    } else {
      _toggleStatus(context);
    }
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text('Task Not Editable'),
        content: Text(
            'This task is already completed or missed and cannot be changed.'),
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, TaskDetails task) {
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: 'Update Task',
        description: 'Are you sure you want to update this task?',
        icon: Icons.update,
        operation: 'Update',
        color: Colors.blue,
        onConfirmed: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => UpdateTaskScreen(task: task)),
          );
        },
        onCanceled: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, TaskDetails task) {
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: 'Delete Task',
        description: 'Are you sure you want to delete this task?',
        icon: Icons.delete_forever,
        operation: 'Delete',
        color: Colors.red,
        onConfirmed: () {
          context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
          Navigator.of(context).pop();
        },
        onCanceled: () => Navigator.of(context).pop(),
      ),
    );
  }
}
