import 'package:flutter/material.dart';
import 'package:mapperapp/feature/taskHome/domain/entity/taskEntity.dart';
import '../wedgit/task_card.dart';

class TaskList extends StatelessWidget {

  final List<TaskDetails> tasks;

  const TaskList({super.key, required this.tasks});
  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(child: Text("No tasks found."));
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
              priority: task.priority,
              status: task.status,
            );
          }).toList(),
        ),
      ),
    );
  }
}
