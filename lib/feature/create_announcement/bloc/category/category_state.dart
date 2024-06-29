part of 'category_cubit.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoadingState extends CategoryState {}

class CategorySuccessState extends CategoryState {
  List<Category> categories;
  CategorySuccessState({required this.categories});
}

class CategoryFailState extends CategoryState {
  final String message;

  CategoryFailState({required this.message});
}
