import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/catogeryBloc/CatogeryBloc.dart';
import '../bloc/catogeryBloc/Catogeryevent.dart';
import '../bloc/catogeryBloc/Catogerystate.dart';


class CategorySelector extends StatefulWidget {
  final void Function(String selectedCategory)? onCategorySelected;

  const CategorySelector({
    super.key,
    this.onCategorySelected,
  });

  @override
  _CategorySelectorState createState() =>
      _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Load categories when the widget is initialized
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
  }

  void _showAddCategoryDialog(BuildContext context) {
    final TextEditingController newCategoryController =
    TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Add New Category"),
          content: TextField(
            controller: newCategoryController,
            decoration: const InputDecoration(
              labelText: "Category Name",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final newCategory = newCategoryController.text.trim();
                if (newCategory.isNotEmpty) {
                  context
                      .read<CategoryBloc>()
                      .add(AddCategoryEvent(categoryName: newCategory));
                  Navigator.of(dialogContext).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Category name cannot be empty."),
                    ),
                  );
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoryError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is CategoryLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () => {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Category",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 8), // Optional spacing between text and icon
                        const Icon(
                          Icons.open_in_new, // Replace with your desired icon
                          size: 18,
                        ),
                      ],
                    ),
                  ),

                  // Text(
                  //   'Category',
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.bold,
                  //     color: Theme.of(context).colorScheme.primary,
                  //   ),
                  // ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => _showAddCategoryDialog(context),
                    icon: const Icon(
                      Icons.add, // Replace with the desired icon
                      size: 18,  // Adjust the size to match the text
                    ),
                    label: const Text(
                      "Add New",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),


                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: state.categories.map((category) {
                  final isSelected = _selectedCategory == category.categoryName;
                  return ChoiceChip(
                    label: Text(category.categoryName),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category.categoryName : null;
                      });
                      if (widget.onCategorySelected != null) {
                        widget.onCategorySelected!(category.categoryName);
                      }
                    },
                    selectedColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        } else {
          return const Center(child: Text('No categories available.'));
        }
      },
    );
  }
}
