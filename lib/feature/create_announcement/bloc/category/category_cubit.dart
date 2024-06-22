import 'package:bloc/bloc.dart';

import '../../../../managers/categories_manager.dart';
import '../../../../models/category.dart';

part 'category_state.dart';

// List<Category> allCategories = [];

class CategoryCubit extends Cubit<CategoryState> {
  final CategoriesManager categoriesManager;

  CategoryCubit({required this.categoriesManager}) : super(CategoryInitial());

  void loadCategories() async {
    emit(CategoryLoadingState());
    try {
      final categories = await categoriesManager.loadCategories();
      CategoriesManager.allCategories = categories;
      emit(CategorySuccessState(categories: categories));
    } catch (e) {
      emit(CategoryFailState());
      rethrow;
    }
  }
}
