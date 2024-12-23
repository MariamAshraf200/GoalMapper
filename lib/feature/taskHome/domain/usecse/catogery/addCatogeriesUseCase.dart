
import '../../../data/model/categoryModel.dart';
import '../../repo_interface/repoCatogery.dart';

class AddCategoryUseCase {
  final CategoryRepository categoryRepository;

  AddCategoryUseCase(this.categoryRepository);

  Future<void> call(CategoryModel category) async {
    return await categoryRepository.addCategory(category);
  }
}
