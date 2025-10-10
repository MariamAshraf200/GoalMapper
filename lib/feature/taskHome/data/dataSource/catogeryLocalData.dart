import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../../../../core/hiveServices.dart';
import '../model/categoryModel.dart';
import 'abstract_data_scource.dart';

class HiveCategoryLocalDataSource implements CategoryLocalDataSource {
  final HiveService hiveService;

  HiveCategoryLocalDataSource(this.hiveService);

  Box<CategoryModel> get categoryBox => hiveService.getCategoryBox();

  @override
  Future<void> addCategory(CategoryModel category) async {
    try {
      final existingCategory = categoryBox.values.any(
        (existing) =>
            existing.categoryName.toLowerCase() ==
            category.categoryName.toLowerCase(),
      );

      if (existingCategory) {
        return; // Exit the function without adding a duplicate
      }

      // Add the category if it doesn't exist
      await categoryBox.add(category);
    } catch (e) {
      if (kDebugMode) debugPrint('Error adding category: $e');
      // Show the error dialog in case of an exception
      rethrow;
    }
  }

  /// Fetch all categories from the Hive box.
  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final categories = categoryBox.values.toList();
      if (kDebugMode) {
        debugPrint('Fetched categories: $categories');
      }
      return categories;
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching categories: $e');
      return [];
    }
  }

  /// Delete a category by its ID.
  @override
  Future<void> deleteCategory(String id) async {
    try {
      final key = categoryBox.keys.firstWhere(
        (key) => categoryBox.get(key)?.id == id,
        orElse: () => null,
      );
      if (key != null) {
        await categoryBox.delete(key);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error deleting category: $e');
      rethrow;
    }
  }

  /// Update a category by its ID.
  @override
  Future<void> updateCategory(CategoryModel updatedCategory) async {
    try {
      final key = categoryBox.keys.firstWhere(
        (key) => categoryBox.get(key)?.id == updatedCategory.id,
        orElse: () => null,
      );
      if (key != null) {
        await categoryBox.put(key, updatedCategory);
        if (kDebugMode) {
          debugPrint('Category updated: $updatedCategory');
        }
      } else {
        if (kDebugMode) {
          debugPrint('Category with ID ${updatedCategory.id} not found for update.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error updating category: $e');
      }
      rethrow;
    }
  }
}
