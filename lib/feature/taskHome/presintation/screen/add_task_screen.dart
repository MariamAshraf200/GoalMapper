import 'package:flutter/material.dart';
import '../Widget/add_task_form.dart';

class AddTaskScreen extends StatelessWidget {
  final String? planId; // Make planId optional

  const AddTaskScreen({super.key, this.planId}); // planId is optional

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
            const Spacer(), // Push the text to the center
            Text(
              'Create New Task',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Spacer(), // Balances the spacing on the right
          ],
        ),
      ),
      body: AddTaskForm(planId: planId), // Pass planId to AddTaskForm
    );
  }
}