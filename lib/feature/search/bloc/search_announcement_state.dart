// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_announcement_cubit.dart';

@immutable
abstract class SearchAnnouncementState {}

class SearchAnnouncementInitial extends SearchAnnouncementState {}

class SearchAnnouncementsLoadingState extends SearchAnnouncementState {}

class SearchAnnouncementsSuccessState extends SearchAnnouncementState {}

class SearchAnnouncementsFailState extends SearchAnnouncementState {
  final String error;
  SearchAnnouncementsFailState({
    required this.error,
  });
}
