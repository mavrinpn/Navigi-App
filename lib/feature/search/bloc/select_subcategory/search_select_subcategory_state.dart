part of 'search_select_subcategory_cubit.dart';

@immutable
abstract class SearchSelectSubcategoryState {}

class SearchSelectSubcategoryInitial extends SearchSelectSubcategoryState {}

class CategoryLoadingState extends SearchSelectSubcategoryState {}

class CategoriesGotState extends SearchSelectSubcategoryState {}

class SubcategoriesLoadingState extends SearchSelectSubcategoryState {}

class SubcategoriesGotState extends SearchSelectSubcategoryState {}

class FiltersLoadingState extends SearchSelectSubcategoryState {}

class FiltersGotState extends SearchSelectSubcategoryState {
  final List<Parameter> parameters;

  FiltersGotState(this.parameters);
}