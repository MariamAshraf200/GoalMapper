import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/plan_entity.dart';
import '../../../domain/entities/taskPlan.dart';
import '../../bloc/bloc.dart';
import '../../bloc/event.dart';

class PlanDetailsSubtaskCard extends StatelessWidget {
  final PlanDetails plan;
  final TaskPlan task;
  const PlanDetailsSubtaskCard({super.key, required this.plan, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: task.status == TaskPlanStatus.done
            ? Colors.green.shade50
            : Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Toggle status
          GestureDetector(
            onTap: () {
              context.read<PlanBloc>().add(
                ToggleTaskStatusEvent(planId: plan.id, task: task),
              );
            },
            child: Icon(
              task.status == TaskPlanStatus.done
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: task.status == TaskPlanStatus.done
                  ? Colors.green
                  : Colors.grey,
            ),
          ),
          const SizedBox(width: 10),
          // Task text
          Expanded(
            child: Text(
              task.text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                decoration: task.status == TaskPlanStatus.done
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Delete icon
          GestureDetector(
            onTap: () {
              context.read<PlanBloc>().add(
                DeleteTaskFromPlanEvent(planId: plan.id, taskId: task.id),
              );
            },
            child: const Icon(
              Icons.delete,
              size: 20,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}

