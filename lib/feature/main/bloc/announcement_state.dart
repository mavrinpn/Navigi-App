part of 'announcement_cubit.dart';

@immutable
abstract class AnnouncementsState {}

class AnnouncementInitial extends AnnouncementsState {}

class AnnouncementsLoadingState extends AnnouncementsState {}

class AnnouncementsSuccessState extends AnnouncementsState {}

class AnnouncementsFailState extends AnnouncementsState {}