part of 'search_announcements_cubit.dart';

abstract class SearchAnnouncementsState {}

class SearchAnnouncementsInitial extends SearchAnnouncementsState {}

class SuccessSearch extends SearchAnnouncementsState {
  List<Announcement> result;

  SuccessSearch({required this.result});
}

class FailSearch extends SearchAnnouncementsState {}

class WaitSearch extends SearchAnnouncementsState {}

class LoadingSearch extends SearchAnnouncementsState {}
