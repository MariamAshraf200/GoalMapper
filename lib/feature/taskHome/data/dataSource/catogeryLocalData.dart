import 'package:hive/hive.dart';

import '../model/categoryModel.dart';

class HiveCategoryLocalDataSource {
  final Box<CategoryModel> categoryBox;

  HiveCategoryLocalDataSource(this.categoryBox);

  Future<void> addCategory(CategoryModel category) async {
    await categoryBox.add(category);
  }

  Future<List<CategoryModel>> getAllCategories() async {
    return categoryBox.values.toList();
  }

  Future<void> deleteCategory(String id) async {
    final key = categoryBox.keys.firstWhere((key) => categoryBox.get(key)?.id == id, orElse: () => null);
    if (key != null) {
      await categoryBox.delete(key);
    }
  }
}
