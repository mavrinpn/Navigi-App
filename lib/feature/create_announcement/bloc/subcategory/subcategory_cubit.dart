import 'package:bloc/bloc.dart';
import 'package:smart/models/category.dart';
import '../../../../managers/categories_manager.dart';
import '../../../../managers/creating_announcement_manager.dart';
import '../../../../models/subcategory.dart';

part 'subcategory_state.dart';

class SubcategoryCubit extends Cubit<SubcategoryState> {
  final CreatingAnnouncementManager creatingManager;
  final CategoriesManager categoriesManager;

  SubcategoryCubit({
    required this.creatingManager,
    required this.categoriesManager,
  }) : super(SubcategoryInitial());

  void loadSubCategories({String? categoryId, String? subcategoryId}) async {
    emit(SubcategoryLoadingState());
    try {
      assert(categoryId != null || subcategoryId != null);
      final List<Subcategory> subcategories;
      if (categoryId != null) {
        creatingManager.setCategory(categoryId);
        subcategories =
            await categoriesManager.loadSubcategoriesByCategory(categoryId);
      } else {
        subcategories = await categoriesManager
            .tryToLoadSubcategoriesBuSubcategory(subcategoryId!);
      }

      emit(SubcategoriesSuccessState(subcategories: subcategories));
    } catch (e) {
      emit(SubcategoryFailState());
      rethrow;
    }
  }

  void loadSubcategory({required String subcategoryId}) async {
    emit(SubcategoryLoadingState());
    try {
      final result = await categoriesManager.getSubcategory(subcategoryId);

      emit(SubcategorySuccessState(
          subcategory: result.subcategory, category: result.category));
    } catch (e) {
      emit(SubcategoryFailState());
      rethrow;
    }
  }
}
