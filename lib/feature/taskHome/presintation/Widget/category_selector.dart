import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/categoryModel.dart';
import '../bloc/catogeryBloc/CatogeryBloc.dart';
import '../bloc/catogeryBloc/Catogeryevent.dart';
import '../bloc/catogeryBloc/Catogerystate.dart';

/// CategorySelector widget for selecting, adding, and deleting categories.
class CategorySelector extends StatefulWidget {
  final void Function(String selectedCategory)? onCategorySelected;

  const CategorySelector({super.key, this.onCategorySelected});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Load categories on widget initialization
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return switch (state) {
          CategoryLoading() => const Center(child: CircularProgressIndicator()),
          CategoryError(:final message) => Center(child: Text('Error: $message')),
          CategoryLoaded(:final categories) =>
              _buildCategoryContent(context, categories),
          _ => const Center(child: Text('No categories available.')),
        };
      },
    );
  }

  Widget _buildCategoryContent(BuildContext context, List<CategoryModel> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: categories.map((category) {
            final isSelected = _selectedCategory == category.categoryName;
            return InputChip(
              label: Text(category.categoryName),
              selected: isSelected,
              onSelected: (_) => _handleCategorySelected(category.categoryName),
              selectedColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () => _handleCategoryDeleted(category),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          "Category",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () => _showAddCategoryDialog(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text("Add New", style: TextStyle(fontSize: 14)),
        ),
      ],
    );
  }

  // ----------------- Logic -----------------

  void _handleCategorySelected(String categoryName) {
    setState(() => _selectedCategory = categoryName);
    widget.onCategorySelected?.call(categoryName);
  }

  void _handleCategoryDeleted(CategoryModel category) {
    context.read<CategoryBloc>().add(DeleteCategoryEvent(id: category.id));
    if (_selectedCategory == category.categoryName) {
      setState(() => _selectedCategory = null);
    }
  }

  void _showAddCategoryDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Add New Category"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: "Category Name",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final newCategory = controller.text.trim();
              if (newCategory.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Category name cannot be empty.")),
                );
                return;
              }
              context.read<CategoryBloc>().add(AddCategoryEvent(categoryName: newCategory));
              Navigator.of(dialogContext).pop();
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
