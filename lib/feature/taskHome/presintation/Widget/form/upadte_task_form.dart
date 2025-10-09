import 'package:flutter/material.dart';
import '../../../../../injection_imports.dart';

class UpdateTaskForm extends StatelessWidget {
  final TaskDetails task;

  const UpdateTaskForm({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return TaskForm(
      mode: TaskFormMode.update,
      task: task,
    );
  }
}
