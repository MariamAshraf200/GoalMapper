import 'package:flutter/material.dart';
import '../../../domain/entity/taskEntity.dart';
import 'task_item_card.dart';

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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      controller: _scrollController,
      itemCount: widget.tasks.length,
      itemBuilder: (context, index) {
        final task = widget.tasks[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TaskItemCard(task: task),
        );
      },
    );
  }
}
