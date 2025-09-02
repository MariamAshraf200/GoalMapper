import 'package:flutter/material.dart';

import '../../domain/entity/task_enum.dart';

class PrioritySelector extends StatelessWidget {
  final TaskPriority selectedPriority;
  final void Function(TaskPriority priority) onPrioritySelected;

  const PrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPrioritySelected,
  });

  @override
  Widget build(BuildContext context) {
    // Use the enum values for priorities
    final List<TaskPriority> priorities = [
      TaskPriority.low,
      TaskPriority.medium,
      TaskPriority.high
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          'Priority',
          style: TextStyle(fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: priorities.map((priority) {
            final bool isSelected = priority == selectedPriority;
            return ChoiceChip(
              label: Text(
                priority.toTaskPriorityString().toLowerCase().capitalize(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              selected: isSelected,
              selectedColor: Theme.of(context).colorScheme.primary,
              onSelected: (selected) {
                if (selected) onPrioritySelected(priority);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

// Helper extension to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
