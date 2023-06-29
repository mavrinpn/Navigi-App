import 'package:bloc/bloc.dart';
import 'package:smart/feature/create/data/creting_announcement_manager.dart';

import '../../../../data/app_repository.dart';
import '../../../../models/subcategory.dart';
import '../../data/categories_manager.dart';

part 'sub_category_state.dart';

class SubCategoryCubit extends Cubit<SubCategoryState> {
  final CreatingAnnouncementManager creatingManager;
  final CategoriesManager categoriesManager;

  SubCategoryCubit({required this.creatingManager, required this.categoriesManager}) : super(SubCategoryInitial()) {
    categoriesManager.subCategoriesState.stream.listen((event) {
      if (event == LoadingStateEnum.loading) emit(SubCategoryLoadingState());
      if (event == LoadingStateEnum.success) emit(SubCategorySuccessState(subcategories: categoriesManager.subcategories));
      if (event == LoadingStateEnum.fail) emit(SubCategoryFailState());
    });
  }

  void loadSubCategories(String categoryId) {
    creatingManager.setCategory(categoryId);
    categoriesManager.loadSubCategories(categoryId);
  }

}
