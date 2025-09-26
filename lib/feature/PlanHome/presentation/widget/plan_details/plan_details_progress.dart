import 'package:flutter/material.dart';

import '../../../domain/entities/taskPlan.dart';

class PlanDetailsProgress extends StatelessWidget {
  final List<TaskPlan> tasks;
  const PlanDetailsProgress({Key? key, required this.tasks}) : super(key: key);

  double _calculateProgress(List<TaskPlan> tasks) {
    if (tasks.isEmpty) return 0.0;
    final completed = tasks.where((t) => t.status == TaskPlanStatus.done).length;
    return completed / tasks.length;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _calculateProgress(tasks);
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
            color: Colors.deepPurple,
            minHeight: 8,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          "${(progress * 100).toInt()}%",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.deepPurple,
          ),
        ),
      ],
    );
  }
}

