import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../../injection_imports.dart';


class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final AddCategoryUseCase addCategoryUseCase;
  final GetAllCategoriesUseCase getAllCategoriesUseCase;
  final DeleteCategoryUseCase deleteCategoryUseCase;

  CategoryBloc({
    required this.addCategoryUseCase,
    required this.getAllCategoriesUseCase,
    required this.deleteCategoryUseCase,
  }) : super(CategoryInitial()) {
    on<LoadCategoriesEvent>(_handleLoadCategories);
    on<AddCategoryEvent>(_handleAddCategory);
    on<DeleteCategoryEvent>(_handleDeleteCategory);
  }

  /// Common executor for async operations with error handling
  Future<void> _execute(
      Emitter<CategoryState> emit,
      Future<void> Function() action,
      ) async {
    emit(CategoryLoading());
    try {
      await action();
    } catch (e) {
      emit(CategoryError("Error: $e"));
    }
  }

  // ---------------- Event Handlers ----------------

  Future<void> _handleLoadCategories(
      LoadCategoriesEvent event,
      Emitter<CategoryState> emit,
      ) async {
    await _execute(emit, () async {
      final categories = await getAllCategoriesUseCase();
      if (categories.isEmpty) {
        final defaultCategory = CategoryModel(
          id: '1',
          categoryName: 'General',
        );
        await addCategoryUseCase(defaultCategory);
        emit(CategoryLoaded([defaultCategory]));
      } else {
        emit(CategoryLoaded(categories));
      }
    });
  }

  Future<void> _handleAddCategory(
      AddCategoryEvent event,
      Emitter<CategoryState> emit,
      ) async {
    await _execute(emit, () async {
      const uuid = Uuid();
      final category = CategoryModel(
        id: uuid.v4(),
        categoryName: event.categoryName,
      );
      await addCategoryUseCase(category);
      add(LoadCategoriesEvent()); // reload after adding
    });
  }

  Future<void> _handleDeleteCategory(
      DeleteCategoryEvent event,
      Emitter<CategoryState> emit,
      ) async {
    await _execute(emit, () async {
      await deleteCategoryUseCase(event.id);
      add(LoadCategoriesEvent()); // reload after deleting
    });
  }
}
