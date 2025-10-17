import 'package:flutter/material.dart';
import '../../../../l10n/l10n_extension.dart';
import '../Widget/form/add_task_form.dart';

class AddTaskScreen extends StatelessWidget {
  final String? planId;

  const AddTaskScreen({super.key, this.planId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              tooltip: context.l10n.close,
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
              context.l10n.createNewTask,
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
      body: AddTaskForm(planId: planId),
    );
  }
}