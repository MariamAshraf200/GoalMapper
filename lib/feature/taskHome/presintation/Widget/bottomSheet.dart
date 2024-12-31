import 'package:flutter/material.dart';
import '../../data/model/categoryModel.dart';

void showCategoryBottomSheet(BuildContext context,
    TextEditingController categoryController, List<CategoryModel> categories) {
  final TextEditingController customCategoryController =
  TextEditingController();

// remove duplicated
  final uniqueCategories = categories
      .map((category) => category.categoryName)
      .toSet()
      .map((name) {
    final originalCategory = categories.firstWhere(
          (category) => category.categoryName == name,
    );
    return CategoryModel(id: originalCategory.id, categoryName: name);
  })
      .toList();


  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a Category',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  childAspectRatio: 4,
                ),
                itemCount: uniqueCategories.length,
                itemBuilder: (context, index) {
                  final category = uniqueCategories[index];
                  return GestureDetector(
                    onTap: () {
                      categoryController.text = category.categoryName;
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Text(
                        category.categoryName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: customCategoryController,
              decoration: const InputDecoration(
                labelText: 'Enter custom category',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              onSubmitted: (value) {
                  categoryController.text = value;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
