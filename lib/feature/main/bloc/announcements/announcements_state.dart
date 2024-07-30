part of 'announcements_cubit.dart';

@immutable
abstract class AnnouncementsState {}

class AnnouncementsInitial extends AnnouncementsState {}

class AnnouncementsLoadingState extends AnnouncementsState {}

class AnnouncementsSuccessState extends AnnouncementsState {}

class AnnouncementsFailState extends AnnouncementsState {}

class AnnouncementsReloadImageState extends AnnouncementsState {}