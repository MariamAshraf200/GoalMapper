import '../../data/model/categoryModel.dart';

abstract class CategoryRepository {
  Future<void> addCategory(CategoryModel category);
  Future<List<CategoryModel>> getAllCategories();
  Future<void> deleteCategory(String id);
}
