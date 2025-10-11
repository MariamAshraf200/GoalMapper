import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/plan_entity.dart';
import '../../../domain/entities/taskPlan.dart';
import '../../bloc/bloc.dart';
import '../../bloc/state.dart';


class PlanDetailsSubtasks extends StatelessWidget {
  final PlanDetails plan;
  final void Function(BuildContext) onAddTask;
  final Widget Function(BuildContext, TaskPlan) subTaskCardBuilder;
  const PlanDetailsSubtasks({Key? key, required this.plan, required this.onAddTask, required this.subTaskCardBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Subtasks",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () => onAddTask(context),
              icon: Icon(Icons.add, color: colorScheme.secondary),
              label: Text(
                "Add Subtask",
                style: TextStyle(color: colorScheme.secondary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        BlocBuilder<PlanBloc, PlanState>(
          builder: (context, state) {
            if (state is TasksLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PlanAndTasksLoaded) {
              final tasks = state.tasks;
              if (tasks.isEmpty) {
                return const Center(
                  child: Text(
                    "No subtasks yet.",
                    style: TextStyle(fontSize: 14),
                  ),
                );
              }
              return Column(
                children: tasks.map((task) => subTaskCardBuilder(context, task)).toList(),
              );
            } else if (state is TaskError) {
              return Center(child: Text("Error: ￼${state.message}￼"));
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
