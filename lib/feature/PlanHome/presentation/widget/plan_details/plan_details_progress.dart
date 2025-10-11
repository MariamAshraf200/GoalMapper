import 'package:flutter/material.dart';

import '../../../domain/entities/taskPlan.dart';

class PlanDetailsProgress extends StatelessWidget {
  final List<TaskPlan> tasks;
  const PlanDetailsProgress({super.key, required this.tasks});

  double _calculateProgress(List<TaskPlan> tasks) {
    if (tasks.isEmpty) return 0.0;
    final completed = tasks.where((t) => t.status == TaskPlanStatus.done).length;
    return completed / tasks.length;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _calculateProgress(tasks);
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: progress,
            color: colorScheme.secondary,
            minHeight: 8,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          "${(progress * 100).toInt()}%",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
