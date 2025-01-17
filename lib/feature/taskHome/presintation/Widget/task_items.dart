import 'package:flutter/material.dart';
import 'package:mapperapp/feature/taskHome/presintation/Widget/task_item_card.dart';

import '../../../../core/constants/app_spaces.dart';
import '../../domain/entity/taskEntity.dart';

class TaskItems extends StatefulWidget {
  const TaskItems({
    super.key,
    required this.tasks,
  });

  final List<TaskDetails> tasks;

  @override
  State<TaskItems> createState() => _TaskItemsState();
}

// confused

class _TaskItemsState extends State<TaskItems> {
  final _scrollController = ScrollController();
  bool _isLoading = false;

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
    }
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: AppSpaces.calculatePaddingFromScreenWidth(context),
      controller: _scrollController,
      itemCount: widget.tasks.length + 1,  // why +1
      itemBuilder: (context, index) {
        if (index == widget.tasks.length) {
          return _isLoading
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox();
        }
        return TaskItemCard(task: widget.tasks[index],);
      },
    );
  }
}