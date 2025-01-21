import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapperapp/feature/taskHome/presintation/bloc/taskBloc/event.dart';
import 'package:mapperapp/feature/taskHome/presintation/Widget/task_item_card.dart';
import 'package:mapperapp/feature/taskHome/presintation/screen/taskTrack.dart';
import '../../domain/entity/taskEntity.dart';
import '../bloc/taskBloc/bloc.dart';

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
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Handle scroll end logic (e.g., pagination)
    }
  }

  void _deleteTask(BuildContext context, String taskId) {
    context.read<TaskBloc>().add(DeleteTaskEvent(taskId));
  }

  void _updateTask(BuildContext context, TaskDetails task) {

  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      controller: _scrollController,
      itemCount: widget.tasks.length,
      itemBuilder: (context, index) {
        final task = widget.tasks[index];
        return Dismissible(
          key: Key(task.id),
          direction: DismissDirection.horizontal,
          background: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.blue,
            child: const Icon(Icons.edit, color: Colors.white),
          ),
          secondaryBackground: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              _deleteTask(context, task.id);
            } else if (direction == DismissDirection.startToEnd) {
              _updateTask(context, task);
            }
          },
          child: TaskItemCard(task: task),
        );
      },
    );
  }
}