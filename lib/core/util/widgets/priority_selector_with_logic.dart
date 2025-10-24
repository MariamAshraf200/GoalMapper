import 'package:flutter/material.dart';
import '../../../feature/taskHome/domain/entity/task_enum.dart';
import 'priority_selector.dart';

/// Core-level wrapper providing mapping between domain `TaskPriority` and
/// the core UI `PrioritySelector`. Keeps mapping centralized and uses
/// localized labels.
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
    final labels = TaskPriority.values.map((p) => p.toPriorityLabel(context)).toList();
    return PrioritySelector(
      priorities: labels,
      selectedPriority: selectedPriority.toPriorityLabel(context),
      onPrioritySelected: (label) {
        final p = TaskPriority.values.firstWhere(
          (pp) => pp.toPriorityLabel(context) == label,
          orElse: () => TaskPriority.medium,
        );
        onPrioritySelected(p);
      },
    );
  }
}
