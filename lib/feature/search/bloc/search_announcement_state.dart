part of 'search_announcement_cubit.dart';

@immutable
abstract class SearchAnnouncementState {}

class SearchAnnouncementInitial extends SearchAnnouncementState {}

class SearchAnnouncementsLoadingState extends SearchAnnouncementState {}

class SearchAnnouncementsSuccessState extends SearchAnnouncementState {}

class SearchAnnouncementsFailState extends SearchAnnouncementState {}
