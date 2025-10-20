import 'package:flutter/material.dart';
import '../../../../l10n/l10n_extension.dart';
import '../../domain/entity/taskEntity.dart';
import '../Widget/form/upadte_task_form.dart';

class UpdateTaskScreen extends StatelessWidget {
  final TaskDetails task;

  const UpdateTaskScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: Row(
                children: [
                  IconButton(
                    tooltip: context.l10n.close,
                    icon: Icon(
                      Icons.close,
                      size: 30,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const Spacer(),
                  Text(
                    context.l10n.updateTask,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ) ??
                        TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Form fills remaining space
            Expanded(child: UpdateTaskForm(task: task)),
          ],
        ),
      ),
    );
  }
}
