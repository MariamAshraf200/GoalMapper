import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../injection_imports.dart';
import '../../bloc/taskBloc/event.dart';

class UpdateTaskForm extends StatelessWidget {
  final TaskDetails task;

  const UpdateTaskForm({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return TaskForm(
      mode: TaskFormMode.update,
      task: task,
      onSubmit: (updatedTask) {
        context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task updated successfully!')),
        );
      },
    );
  }
}
