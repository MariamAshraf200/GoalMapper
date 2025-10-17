import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapperapp/l10n/app_localizations.dart';

import '../../../../../injection_imports.dart';

class PlanFiltersWidget extends StatelessWidget {
  final String? selectedCategory;
  final PlanStatus? selectedStatus;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<PlanStatus?> onStatusChanged;

  const PlanFiltersWidget({
    super.key,
    required this.selectedCategory,
    required this.selectedStatus,
    required this.onCategoryChanged,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              List<String> categories = ["All"];
              if (state is CategoryLoaded) {
                categories.addAll(state.categories.map((c) => c.categoryName));
              }
              return _FilterDropdown<String>(
                icon: Icon(Icons.folder, color: colorScheme.secondary),
                value: selectedCategory,
                hint: l10n.selectCategory,
                items: [
                  DropdownMenuItem<String>(value: null, child: Text(l10n.allCategories)),
                  ...categories.where((c) => c != "All").map(
                    (c) => DropdownMenuItem<String>(value: c, child: Text(c)),
                  ),
                ],
                onChanged: onCategoryChanged,
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _FilterDropdown<PlanStatus>(
            icon: const Icon(Icons.check_circle, color: Colors.green),
            value: selectedStatus,
            hint: l10n.selectStatus,
            items: [
              DropdownMenuItem<PlanStatus>(value: null, child: Text(l10n.allStatuses)),
              ...PlanStatus.values.where((status) => status != PlanStatus.all).map(
                (status) => DropdownMenuItem<PlanStatus>(
                  value: status,
                  child: Text(status.localized(context)),
                ),
              ),
            ],
            onChanged: onStatusChanged,
          ),
        ),
      ],
    );
  }
}

class _FilterDropdown<T> extends StatelessWidget {
  final Widget icon;
  final T? value;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _FilterDropdown({
    required this.icon,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withAlpha(20), blurRadius: 5)],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<T>(
              value: value,
              hint: Text(
                hint,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              isExpanded: true,
              underline: const SizedBox(),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
