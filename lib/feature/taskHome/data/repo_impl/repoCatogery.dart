import '../../domain/repo_interface/repoCatogery.dart';
import '../dataSource/catogeryLocalData.dart';
import '../model/categoryModel.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final HiveCategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl(this.localDataSource);

  @override
  Future<void> addCategory(CategoryModel category) async {
    await localDataSource.addCategory(category);
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    return await localDataSource.getAllCategories();
  }

  @override
  Future<void> deleteCategory(String id) async {
    await localDataSource.deleteCategory(id);
  }
}
