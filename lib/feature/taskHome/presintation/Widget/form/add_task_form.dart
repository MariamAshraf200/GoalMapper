import 'package:flutter/material.dart';
import '../../../../../injection_imports.dart';
import 'task_ form.dart';

class AddTaskForm extends StatelessWidget {
  final String? planId;

  const AddTaskForm({super.key, this.planId});

  @override
  Widget build(BuildContext context) {
    return TaskForm(
      mode: TaskFormMode.add,
      planId: planId,
    );
  }
}
