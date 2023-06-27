part of 'item_search_cubit.dart';

abstract class ItemSearchState {}

class ItemSearchInitial extends ItemSearchState {}

class SearchLoadingState extends ItemSearchState {}

class SearchSuccessState extends ItemSearchState {
  List<SubCategoryItem> items;
  SearchSuccessState({required this.items});
}

class SearchEmptyState extends ItemSearchState {}

class SearchFailState extends ItemSearchState {}