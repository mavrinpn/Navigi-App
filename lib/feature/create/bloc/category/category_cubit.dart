import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart/feature/create/data/creting_announcement_manager.dart';

import '../../../../data/app_repository.dart';
import '../../../../models/category.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CreatingAnnouncementManager creatingManager;

  CategoryCubit({required this.creatingManager}) : super(CategoryInitial()) {
    creatingManager.categoriesState.stream.listen((event) {
      if (event == LoadingStateEnum.loading) emit(CategoryLoadingState());
      if (event == LoadingStateEnum.success) emit(CategorySuccessState(categories: creatingManager.categories));
      if (event == LoadingStateEnum.fail) emit(CategoryFailState());
    });
  }
}
