part of 'subcategory_cubit.dart';

abstract class SubcategoryState {}

class SubcategoryInitial extends SubcategoryState {}

class SubcategoryLoadingState extends SubcategoryState {}

class SubcategorySuccessState extends SubcategoryState {
  List<Subcategory> subcategories;
  SubcategorySuccessState({required this.subcategories});
}

class SubcategoryFailState extends SubcategoryState {}
