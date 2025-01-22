import 'package:flutter/material.dart';
import '../../domain/entity/taskEntity.dart';
import '../Widget/upadte_task_form.dart';

class UpdateTaskScreen extends StatelessWidget {
  final TaskDetails task;

  const UpdateTaskScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              tooltip: "Close",
              icon: Icon(
                Icons.close,
                color: Colors.red[400],
                size: 35,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const Spacer(),
            Text(
              'Update Task',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      body: UpdateTaskForm(task: task),
    );
  }
}
