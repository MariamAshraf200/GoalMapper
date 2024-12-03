import 'package:flutter/material.dart';

import '../../domain/entity/taskEntity.dart';

class InProgressScreen extends StatelessWidget {
  final List<TaskEntity> tasks; // Accept a list of tasks

  // Constructor to pass the tasks
  const InProgressScreen({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter tasks that are 'In Progress'
    final inProgressTasks = tasks.where((task) => task.status == 'In Progress').toList();

    // If there are no tasks in progress, show a message
    if (inProgressTasks.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            "No tasks in progress yet.",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    }

    // Display the list of 'In Progress' tasks
    return Scaffold(
      appBar: AppBar(
        title: const Text("In Progress Tasks"),
      ),
      body: ListView.builder(
        itemCount: inProgressTasks.length,
        itemBuilder: (context, index) {
          final task = inProgressTasks[index];
          return ListTile(
            title: Text(task.title), // Display task title (update based on your TaskEntity model)
            subtitle: Text(task.description), // Display task description (update based on your TaskEntity model)
            trailing: Text(task.status), // Display task status
          );
        },
      ),
    );
  }
}
