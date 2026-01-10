abstract class CategoryEvent {}

class LoadCategoriesEvent extends CategoryEvent {}

class AddCategoryEvent extends CategoryEvent {
  final String categoryName;

  AddCategoryEvent({required this.categoryName});
}

class DeleteCategoryEvent extends CategoryEvent {
  final String id;

  DeleteCategoryEvent({required this.id});
}
