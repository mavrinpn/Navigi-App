import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../data/app_repository.dart';
import '../../../../models/subCategory.dart';

part 'sub_category_state.dart';

class SubCategoryCubit extends Cubit<SubCategoryState> {
  final AppRepository appRepository;

  SubCategoryCubit({required this.appRepository}) : super(SubCategoryInitial()) {
    appRepository.subCategoriesState.stream.listen((event) {
      if (event == LoadingStateEnum.loading) emit(SubCategoryLoadingState());
      if (event == LoadingStateEnum.success) emit(SubCategorySuccessState(subcategories: appRepository.subcategories));
      if (event == LoadingStateEnum.fail) emit(SubCategoryFailState());
    });
  }

  void loadSubCategories(String categoryId) {
    appRepository.loadSubCategories(categoryId);
  }

}
