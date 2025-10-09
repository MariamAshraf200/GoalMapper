import 'package:flutter/material.dart';

/// A simple, reusable PrioritySelector that lives in `core`.
///
/// This widget is UI-only and decoupled from feature-specific enums. Use
/// a feature-level adapter to map your TaskPriority enum to string labels
/// if needed.
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
          'Priority',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: priorities.map((priority) {
            final bool isSelected = priority == selectedPriority;
            return ChoiceChip(
              label: Text(
                priority.capitalize(),
                style: const TextStyle(
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

extension StringCapitalize on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

