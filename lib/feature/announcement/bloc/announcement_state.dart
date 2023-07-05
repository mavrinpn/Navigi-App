part of 'announcement_cubit.dart';

abstract class AnnouncementState {}

class AnnouncementInitial extends AnnouncementState {}

class AnnouncementLoadingState extends AnnouncementState {}

class AnnouncementSuccessState extends AnnouncementState {
  Announcement data;
  AnnouncementSuccessState({required this.data});
}

class AnnouncementFailState extends AnnouncementState {}