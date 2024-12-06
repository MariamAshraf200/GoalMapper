import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entity/taskEntity.dart';
import '../Widget/customContainerTask.dart';

class TaskListScreen extends StatelessWidget {
  final List<TaskEntity> tasks; // Accept tasks as a parameter.

  // Constructor to pass tasks
   TaskListScreen({Key? key, required this.tasks}) : super(key: key);
  final uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    String uniqueTaskId = uuid.v4();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Display the number of tasks
          Text(
            "You have ${tasks.length} Tasks",
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Iterate through the tasks and display each one
          ...tasks.map((task) => TaskCard(
            title: task.title,
            description: task.description,
            date: task.date,
            time: task.time,
            priority: task.priority,
            priorityColor: _getPriorityColor(task.priority), onViewClicked: () {  }, taskId: uniqueTaskId, // Example of how to assign a color based on priority


          )),
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
