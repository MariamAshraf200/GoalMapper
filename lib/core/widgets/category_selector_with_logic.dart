import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        List<String> names = ['General'];
        if (state is CategoryLoaded) {
          names = state.categories.map((c) => c.categoryName).toList();
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
                title: const Text('Add Category'),
                content: TextField(
                  controller: controller,
                  decoration: const InputDecoration(hintText: 'Category name'),
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                  TextButton(onPressed: () => Navigator.of(ctx).pop(controller.text.trim()), child: const Text('Add')),
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
