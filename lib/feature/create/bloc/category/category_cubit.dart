import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../data/app_repository.dart';
import '../../../../models/category.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final AppRepository appRepository;

  CategoryCubit({required this.appRepository}) : super(CategoryInitial()) {
    appRepository.categoriesState.stream.listen((event) {
      if (event == LoadingStateEnum.loading) emit(CategoryLoadingState());
      if (event == LoadingStateEnum.success) emit(CategorySuccessState(categories: appRepository.categories));
      if (event == LoadingStateEnum.fail) emit(CategoryFailState());
    });
  }
}
