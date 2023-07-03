import 'package:bloc/bloc.dart';
import '../../../../data/app_repository.dart';
import '../../../../models/subcategory.dart';
import '../../data/categories_manager.dart';
import '../../data/creating_announcement_manager.dart';

part 'subcategory_state.dart';

class SubcategoryCubit extends Cubit<SubcategoryState> {
  final CreatingAnnouncementManager creatingManager;
  final CategoriesManager categoriesManager;

  SubcategoryCubit({required this.creatingManager, required this.categoriesManager}) : super(SubcategoryInitial()) {
    categoriesManager.subCategoriesState.stream.listen((event) {
      if (event == LoadingStateEnum.loading) emit(SubcategoryLoadingState());
      if (event == LoadingStateEnum.success) emit(SubcategorySuccessState(subcategories: categoriesManager.subcategories));
      if (event == LoadingStateEnum.fail) emit(SubcategoryFailState());
    });
  }

  void loadSubCategories(String categoryId) {
    creatingManager.setCategory(categoryId);
    categoriesManager.loadSubCategories(categoryId);
  }

}
