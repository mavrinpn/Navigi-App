part of 'related_announcement_cubit.dart';

abstract class RelatedAnnouncementState extends Equatable {}

class RelatedAnnouncementInitial extends RelatedAnnouncementState {
  @override
  List<Object?> get props => [];
}

class RelatedAnnouncementsLoadingState extends RelatedAnnouncementState {
  @override
  List<Object?> get props => [];
}

class RelatedAnnouncementsSuccessState extends RelatedAnnouncementState {
  final List<Announcement> announcements;

  RelatedAnnouncementsSuccessState({required this.announcements});
  @override
  List<Object?> get props => [announcements];
}

class RelatedAnnouncementsFailState extends RelatedAnnouncementState {
  @override
  List<Object?> get props => [];
}
