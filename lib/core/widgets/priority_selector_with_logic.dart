import 'package:flutter/material.dart';
import '../../feature/taskHome/domain/entity/task_enum.dart';
import 'priority_selector.dart';

/// Core-level wrapper providing mapping between domain `TaskPriority` and
/// the core UI `PrioritySelector`. Keeps mapping centralized.
class PrioritySelectorWithLogic extends StatelessWidget {
  final TaskPriority selectedPriority;
  final ValueChanged<TaskPriority> onPrioritySelected;

  const PrioritySelectorWithLogic({
    super.key,
    required this.selectedPriority,
    required this.onPrioritySelected,
  });

  @override
  Widget build(BuildContext context) {
    final labels = TaskPriority.values.map((p) => p.toTaskPriorityString()).toList();
    return PrioritySelector(
      priorities: labels,
      selectedPriority: selectedPriority.toTaskPriorityString(),
      onPrioritySelected: (label) {
        final p = TaskPriorityExtension.fromString(label);
        onPrioritySelected(p);
      },
    );
  }
}

