part of 'search_announcements_cubit.dart';

abstract class SearchItemsState {}

class SearchItemsInitial extends SearchItemsState {}

class SearchItemsSuccess extends SearchItemsState {
  List<SubcategoryItem> result;

  SearchItemsSuccess({required this.result});
}

class SearchItemsFail extends SearchItemsState {}

class SearchItemsWait extends SearchItemsState {}

class SearchItemsLoading extends SearchItemsState {}
