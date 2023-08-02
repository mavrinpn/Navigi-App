part of 'search_announcements_cubit.dart';

abstract class SearchAnnouncementsState {}

class SearchAnnouncementsInitial extends SearchAnnouncementsState {}

class SearchSuccess extends SearchAnnouncementsState {
  List<SubCategoryItem> result;

  SearchSuccess({required this.result});
}

class SearchFail extends SearchAnnouncementsState {}

class SearchWait extends SearchAnnouncementsState {}

class SearchLoading extends SearchAnnouncementsState {}
