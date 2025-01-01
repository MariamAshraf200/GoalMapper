import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../data/model/categoryModel.dart';
import '../../../domain/usecse/catogery/DeleteCategoryUseCase.dart';
import '../../../domain/usecse/catogery/GetAllCategoriesUseCase].dart';
import '../../../domain/usecse/catogery/addCatogeriesUseCase.dart';
import 'Catogeryevent.dart';
import 'Catogerystate.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final AddCategoryUseCase addCategoryUseCase;
  final GetAllCategoriesUseCase getAllCategoriesUseCase;
  final DeleteCategoryUseCase deleteCategoryUseCase;

  CategoryBloc({
    required this.addCategoryUseCase,
    required this.getAllCategoriesUseCase,
    required this.deleteCategoryUseCase,
  }) : super(CategoryInitial()) {


    on<LoadCategoriesEvent>((event, emit) async {
      emit(CategoryLoading()); // Start with loading state
      try {
        final categories = await getAllCategoriesUseCase();
        if (categories.isEmpty) {
          // Add a default category if none exist
          var defaultCategory = CategoryModel(id: '1', categoryName: 'General');
          await addCategoryUseCase(defaultCategory);
          emit(CategoryLoaded([defaultCategory])); // Emit default category
        } else {
          emit(CategoryLoaded(categories)); // Emit loaded state with categories
        }
      } catch (e) {
        emit(CategoryError(e.toString())); // Emit error state if fetching fails
      }
    });

    on<AddCategoryEvent>((event, emit) async {
      emit(CategoryLoading());
      try {
        const uuid = Uuid();
        final category = CategoryModel(
          categoryName: event.categoryName,
          id: uuid.v4(),
        );
        await addCategoryUseCase(category);
        add(LoadCategoriesEvent());
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    on<DeleteCategoryEvent>((event, emit) async {
      emit(CategoryLoading());
      try {
        await deleteCategoryUseCase(event.id);
        add(LoadCategoriesEvent());
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });
  }
}
