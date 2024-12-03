import 'package:flutter/material.dart';
import '../../domain/entity/taskEntity.dart';
import '../Widget/customContainerTask.dart'; // Assuming you have a TaskCard widget

class DoneScreen extends StatelessWidget {
  final List<TaskEntity> tasks; // Accept tasks as a parameter

  // Constructor to pass tasks
  const DoneScreen({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter tasks that are marked as "Done"
    final doneTasks = tasks.where((task) => task.status == 'Done').toList();

    return Scaffold(
      body: doneTasks.isEmpty
          ? const Center(child: Text('No tasks are done yet.'))
          : ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            "You have ${doneTasks.length} Done Tasks",
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Iterate through the filtered tasks and display each one
          ...doneTasks.map((task) => TaskCard(
            title: task.title,
            description: task.description,
            date: task.date,
            time: task.time,
            priority: task.priority,
            priorityColor: _getPriorityColor(task.priority),
            onClicked: () {
              // Define what happens when a task is clicked
            },
          )).toList(),
        ],
      ),
    );
  }

  // Helper function to return priority color based on task priority
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
