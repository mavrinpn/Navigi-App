import 'package:bloc/bloc.dart';
import 'package:smart/feature/create/data/creting_announcement_manager.dart';

import '../../../../data/app_repository.dart';
import '../../../../models/subcategory.dart';

part 'sub_category_state.dart';

class SubCategoryCubit extends Cubit<SubCategoryState> {
  final CreatingAnnouncementManager creatingManager;

  SubCategoryCubit({required this.creatingManager}) : super(SubCategoryInitial()) {
    creatingManager.subCategoriesState.stream.listen((event) {
      if (event == LoadingStateEnum.loading) emit(SubCategoryLoadingState());
      if (event == LoadingStateEnum.success) emit(SubCategorySuccessState(subcategories: creatingManager.subcategories));
      if (event == LoadingStateEnum.fail) emit(SubCategoryFailState());
    });
  }

  void loadSubCategories(String categoryId) {
    creatingManager.loadSubCategories(categoryId);
  }

}
