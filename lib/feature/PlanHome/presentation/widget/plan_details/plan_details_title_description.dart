import 'package:flutter/material.dart';

import '../../../domain/entities/plan_entity.dart';

class PlanDetailsTitleDescription extends StatelessWidget {
  final PlanDetails plan;
  const PlanDetailsTitleDescription({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          plan.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (plan.description.isNotEmpty)
          Text(
            plan.description,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
      ],
    );
  }
}

