part of 'search_announcements_cubit.dart';

abstract class SearchItemsState {}

class SearchItemsInitial extends SearchItemsState {}

class SearchItemsSuccess extends SearchItemsState {
  List<KeyWord> result;
  String currentQuery;

  SearchItemsSuccess({
    required this.result,
    required this.currentQuery,
  });
}

class SearchItemsFail extends SearchItemsState {}

class SearchItemsWait extends SearchItemsState {}

class SearchItemsLoading extends SearchItemsState {}
