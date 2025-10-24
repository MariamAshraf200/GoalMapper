import 'package:flutter/material.dart';
import '../../../l10n/l10n_extension.dart';

/// A simple, reusable PrioritySelector that lives in `core`.
///
/// This widget is UI-only and accepts already-localized string labels.
/// A feature-level adapter (like `PrioritySelectorWithLogic`) should map
/// domain enums to localized labels and convert selections back to enums.
class PrioritySelector extends StatelessWidget {
  final List<String> priorities;
  final String selectedPriority;
  final ValueChanged<String> onPrioritySelected;

  const PrioritySelector({
    super.key,
    required this.priorities,
    required this.selectedPriority,
    required this.onPrioritySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.selectPriority,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: priorities.map((label) {
            final bool isSelected = label == selectedPriority;
            return ChoiceChip(
              label: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              selected: isSelected,
              selectedColor: Theme.of(context).colorScheme.primary,
              onSelected: (selected) {
                if (selected) onPrioritySelected(label);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
