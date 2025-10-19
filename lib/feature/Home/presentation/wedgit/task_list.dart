import 'package:flutter/material.dart';
import 'package:mapperapp/feature/taskHome/domain/entity/taskEntity.dart';
import '../wedgit/task_card.dart';
import 'package:mapperapp/l10n/app_localizations.dart';
import 'package:mapperapp/feature/taskHome/domain/entity/task_enum.dart';

class TaskList extends StatelessWidget {

  final List<TaskDetails> tasks;

  const TaskList({super.key, required this.tasks});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (tasks.isEmpty) {
      return Center(child: Text(l10n.noTasksFound));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: tasks.map((task) {
            return TaskCard(
              title: task.title,
              description: task.description,
              time: task.time,
              priority: TaskPriorityExtension.fromString(task.priority),
              status: task.status,
            );
          }).toList(),
        ),
      ),
    );
  }
}
