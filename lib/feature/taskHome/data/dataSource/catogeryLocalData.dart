import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../../../../core/hiveServices.dart';
import '../../../../core/util/widgets/error_dilog.dart';
import '../model/categoryModel.dart';

class HiveCategoryLocalDataSource {
  final HiveService hiveService;

  HiveCategoryLocalDataSource(this.hiveService);

  Box<CategoryModel> get categoryBox => hiveService.getCategoryBox();




  Future<void> addCategory(CategoryModel category) async {
    try {
      final existingCategory = categoryBox.values.any(
            (existing) => existing.categoryName.toLowerCase() == category.categoryName.toLowerCase(),
      );

      if (existingCategory) {
        showErrorDialog('Category "${category.categoryName}" already exists.');
        return; // Exit the function without adding a duplicate
      }

      // Add the category if it doesn't exist
      await categoryBox.add(category);

    } catch (e) {
      print('Error adding category: $e');
      // Show the error dialog in case of an exception
      showErrorDialog('Error adding category: $e');
      rethrow;
    }
  }


  /// Fetch all categories from the Hive box.
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final categories = categoryBox.values.toList();
      if (kDebugMode) {
        print('Fetched categories: $categories');
      }
      return categories;
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }


  /// Delete a category by its ID.
  Future<void> deleteCategory(String id) async {
    try {
    //ToDo  categoryBox.delete(id);

      final key = categoryBox.keys.firstWhere(
            (key) => categoryBox.get(key)?.id == id,
        orElse: () => null,
      );
      if (key != null) {
        await categoryBox.delete(key);
        if (kDebugMode) {
          print('Category with ID $id deleted.');
        }
      } else {
        if (kDebugMode) {
          print('Category with ID $id not found.');
        }
      }
    } catch (e) {
      print('Error deleting category: $e');
      rethrow;
    }
  }

  /// Update a category by its ID.
  Future<void> updateCategory(CategoryModel updatedCategory) async {
    try {

      final key = categoryBox.keys.firstWhere(
            (key) => categoryBox.get(key)?.id == updatedCategory.id,
        orElse: () => null,
      );
      if (key != null) {
        await categoryBox.put(key, updatedCategory);
        if (kDebugMode) {
          print('Category updated: $updatedCategory');
        }
      } else {
        if (kDebugMode) {
          print('Category with ID ${updatedCategory.id} not found for update.');
        }
      }
    } catch (e) {
      print('Error updating category: $e');
      rethrow;
    }
  }
}
