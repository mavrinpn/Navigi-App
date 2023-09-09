import 'package:bloc/bloc.dart';
import '../../../../managers/categories_manager.dart';
import '../../../../managers/creating_announcement_manager.dart';
import '../../../../models/subcategory.dart';

part 'subcategory_state.dart';

class SubcategoryCubit extends Cubit<SubcategoryState> {
  final CreatingAnnouncementManager creatingManager;
  final CategoriesManager categoriesManager;

  SubcategoryCubit({required this.creatingManager, required this.categoriesManager}) : super(SubcategoryInitial());

  void loadSubCategories(String categoryId) async {
    emit(SubcategoryLoadingState());
    try {
      creatingManager.setCategory(categoryId);
      await categoriesManager.loadSubcategory(categoryId);
      emit(SubcategorySuccessState(subcategories: categoriesManager.subcategories));
    } catch (e) {
      emit(SubcategoryFailState());
      rethrow;
    }
  }

}
