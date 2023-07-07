import 'package:bloc/bloc.dart';

import '../../../../models/category.dart';
import '../../../../services/managers/categories_manager.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoriesManager categoriesManager;

  CategoryCubit({required this.categoriesManager}) : super(CategoryInitial());

  void loadCategories() async {
    emit(CategoryLoadingState());
    try{
      await categoriesManager.loadCategories();
      emit(CategorySuccessState(categories: categoriesManager.categories));
    } catch (e) {
      emit(CategoryFailState());
      rethrow;
    }
  }
}
