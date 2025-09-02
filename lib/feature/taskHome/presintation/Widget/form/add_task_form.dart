import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../injection_imports.dart';


class AddTaskForm extends StatelessWidget {
  final String? planId;

  const AddTaskForm({super.key, this.planId});

  @override
  Widget build(BuildContext context) {
    return TaskForm(
      mode: TaskFormMode.add,
      planId: planId,
      onSubmit: (task) {
        context.read<TaskBloc>().add(AddTaskEvent(task, planId: planId));
        if (planId != null) {
          context.read<PlanBloc>().add(AddTaskToPlanEvent(task: task, planId: planId!));
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task added successfully!')),
        );
      },
    );
  }
}
