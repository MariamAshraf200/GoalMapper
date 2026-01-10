import '../../../data/model/categoryModel.dart';
abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categories;
  CategoryLoaded(this.categories);
  // Utility method to check if a category exists by name
  bool containsCategory(String categoryName) {
    return categories.any((category) => category.categoryName == categoryName);
  }
}

class CategoryError extends CategoryState {
  final String message             ;
  CategoryError(this.message);
}
