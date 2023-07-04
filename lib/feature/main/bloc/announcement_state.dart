part of 'announcement_cubit.dart';

@immutable
abstract class AnnouncementState {}

class AnnouncementInitial extends AnnouncementState {}

class AnnouncementsLoadingState extends AnnouncementState {}

class AnnouncementsSuccessState extends AnnouncementState {}

class AnnouncementsFailState extends AnnouncementState {}