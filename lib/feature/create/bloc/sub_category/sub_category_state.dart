part of 'sub_category_cubit.dart';

abstract class SubCategoryState {}

class SubCategoryInitial extends SubCategoryState {}

class SubCategoryLoadingState extends SubCategoryState {}

class SubCategorySuccessState extends SubCategoryState {
  List<SubCategory> subcategories;
  SubCategorySuccessState({required this.subcategories});
}

class SubCategoryFailState extends SubCategoryState {}
