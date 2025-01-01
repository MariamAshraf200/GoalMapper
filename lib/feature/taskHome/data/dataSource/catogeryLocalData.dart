import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../../../../core/hiveServices.dart';
import '../model/categoryModel.dart';

// class HiveCategoryLocalDataSource {
//   final Box<CategoryModel> categoryBox;
//
//   HiveCategoryLocalDataSource(this.categoryBox);
//
//   Future<void> addCategory(CategoryModel category) async {
//     await categoryBox.add(category);
//   }
//
//   Future<List<CategoryModel>> getAllCategories() async {
//     final categories = categoryBox.values.toList();
//     if (kDebugMode) {
//       print('Fetched categories: $categories');
//     } // Debugging output
//     return categories;
//   }
//
//
//   Future<List<CategoryModel>> fetchCategoriesOnce() async {
//   final categories = categoryBox.values.toList();
//   if (kDebugMode) {
//     print('Fetched categories: $categories');
//   } // Debugging output
//   return categories;
//   }
//
//
//   Future<void> deleteCategory(String id) async {
//     final key = categoryBox.keys.firstWhere((key) => categoryBox.get(key)?.id == id, orElse: () => null);
//     if (key != null) {
//       await categoryBox.delete(key);
//     }
//   }
// }
class HiveCategoryLocalDataSource {
  final HiveService hiveService;

  HiveCategoryLocalDataSource(this.hiveService);

  Box<CategoryModel> get categoryBox => hiveService.getCategoryBox();

  /// Add a new category to the Hive box.
  Future<void> addCategory(CategoryModel category) async {
    try {
      await categoryBox.add(category);
      if (kDebugMode) {
        print('Category added: $category');
      }
    } catch (e) {
      print('Error adding category: $e');
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

  /// Fetch categories once, without real-time updates.
  Future<List<CategoryModel>> fetchCategoriesOnce() async {
    try {
      final categories = categoryBox.values.toList();
      if (kDebugMode) {
        print('Fetched categories once: $categories');
      }
      return categories;
    } catch (e) {
      print('Error fetching categories once: $e');
      return [];
    }
  }

  /// Delete a category by its ID.
  Future<void> deleteCategory(String id) async {
    try {
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
