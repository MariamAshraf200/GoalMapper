import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapperapp/feature/taskHome/presintation/bloc/taskBloc/event.dart';
import 'package:mapperapp/feature/taskHome/presintation/Widget/task_item_card.dart';
import '../../domain/entity/taskEntity.dart';
import '../bloc/taskBloc/bloc.dart';
import '../screen/upadte_task_form.dart';

class TaskItems extends StatefulWidget {
  const TaskItems({
    super.key,
    required this.tasks,
  });

  final List<TaskDetails> tasks;

  @override
  State<TaskItems> createState() => _TaskItemsState();
}

class _TaskItemsState extends State<TaskItems> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      // Trigger pagination or load more tasks
    }
  }

  void _deleteTask(BuildContext context, String taskId) {
    context.read<TaskBloc>().add(DeleteTaskEvent(taskId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task deleted successfully')),
    );
  }

  void _updateTask(BuildContext context, TaskDetails task)  {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateTaskScreen(task: task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      controller: _scrollController,
      itemCount: widget.tasks.length ,
      itemBuilder: (context, index) {
        final task = widget.tasks[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Dismissible(
            key: Key(task.id),
            direction: DismissDirection.horizontal,
            background: _buildDismissBackground(
              color: Colors.blue,
              icon: Icons.edit,
              alignment: Alignment.centerLeft,
            ),
            secondaryBackground: _buildDismissBackground(
              color: Colors.red,
              icon: Icons.delete,
              alignment: Alignment.centerRight,
            ),
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                _deleteTask(context, task.id);
              } else if (direction == DismissDirection.startToEnd) {
                _updateTask(context, task);
              }
            },
            child: TaskItemCard(task: task),
          ),
        );
      },
    );
  }

  Widget _buildDismissBackground({
    required Color color,
    required IconData icon,
    required Alignment alignment,
  }) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: color,
      child: Icon(icon, color: Colors.white),
    );
  }
}
