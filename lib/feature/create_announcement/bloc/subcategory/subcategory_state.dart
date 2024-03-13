part of 'subcategory_cubit.dart';

abstract class SubcategoryState {}

class SubcategoryInitial extends SubcategoryState {}

class SubcategoryLoadingState extends SubcategoryState {}

class SubcategoriesSuccessState extends SubcategoryState {
  List<Subcategory> subcategories;
  SubcategoriesSuccessState({required this.subcategories});
}

class SubcategorySuccessState extends SubcategoryState {
  Subcategory subcategory;
  Category category;
  SubcategorySuccessState({
    required this.subcategory,
    required this.category,
  });
}

class SubcategoryFailState extends SubcategoryState {}
