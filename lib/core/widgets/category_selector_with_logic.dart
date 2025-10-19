import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapperapp/l10n/app_localizations.dart';
import '../../feature/taskHome/presintation/bloc/catogeryBloc/CatogeryBloc.dart';
import '../../feature/taskHome/presintation/bloc/catogeryBloc/Catogeryevent.dart';
import '../../feature/taskHome/presintation/bloc/catogeryBloc/Catogerystate.dart';
import '../../feature/taskHome/data/model/categoryModel.dart';
import 'category_selector.dart';

/// Core widget that bundles UI (core CategorySelector) with Feature Bloc wiring.
/// Use this when you want the selector to load categories and dispatch add/delete
/// events automatically. Keeps form code very small.
class CategorySelectorWithLogic extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String>? onCategorySelected;

  const CategorySelectorWithLogic({
    super.key,
    this.selectedCategory,
    this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        List<String> names = [l10n.general];
        if (state is CategoryLoaded) {
          names = state.categories.map((c) => c.categoryName == 'General' ? l10n.general : c.categoryName).toList();
        }

        return CategorySelector(
          categories: names,
          selectedCategory: selectedCategory,
          onCategorySelected: onCategorySelected,
          onAddCategory: () async {
            final controller = TextEditingController();
            final result = await showDialog<String>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(l10n.addCategory),
                content: TextField(
                  controller: controller,
                  decoration: InputDecoration(hintText: l10n.categoryName),
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(l10n.cancel)),
                  TextButton(onPressed: () => Navigator.of(ctx).pop(controller.text.trim()), child: Text(l10n.add)),
                ],
              ),
            );

            if (result != null && result.isNotEmpty) {
              context.read<CategoryBloc>().add(AddCategoryEvent(categoryName: result));
            }
          },
          onDeleteCategory: (name) {
            if (state is CategoryLoaded) {
              final model = state.categories.firstWhere((c) => c.categoryName == name, orElse: () => CategoryModel(id: '', categoryName: ''));
              if (model.id.isNotEmpty) {
                context.read<CategoryBloc>().add(DeleteCategoryEvent(id: model.id));
              }
            }
          },
        );
      },
    );
  }
}
