part of 'item_search_cubit.dart';

abstract class ItemSearchState {}

class ItemSearchInitial extends ItemSearchState {}

class SearchLoadingState extends ItemSearchState {}

class SearchSuccessState extends ItemSearchState {}

class SearchEmptyState extends ItemSearchState {}

class SearchFailState extends ItemSearchState {}