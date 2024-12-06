import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entity/taskEntity.dart';
import '../Widget/customContainerTask.dart'; // Assuming you have a TaskCard widget

class DoneScreen extends StatelessWidget {
  final List<TaskEntity> tasks; // Accept tasks as a parameter

   DoneScreen({Key? key, required this.tasks}) : super(key: key);
  final uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    final doneTasks = tasks.where((task) => task.status == 'Done').toList();
    String uniqueTaskId = uuid.v4();

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
                ...doneTasks
                    .map((task) => TaskCard(
                          title: task.title,
                          description: task.description,
                          date: task.date,
                          time: task.time,
                          priority: task.priority,
                          priorityColor: _getPriorityColor(task.priority),
                          onViewClicked: () {},
                  taskId: uniqueTaskId,

                ))
                    .toList(),
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
