
import '../../repo_interface/repoCatogery.dart';

class DeleteCategoryUseCase {
  final CategoryRepository categoryRepository;

  DeleteCategoryUseCase(this.categoryRepository);

  Future<void> call(String id) async {
    return await categoryRepository.deleteCategory(id);
  }
}
