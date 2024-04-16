part of 'creating_announcement_cubit.dart';

@immutable
abstract class CreatingAnnouncementState {}

class CreatingAnnouncementInitial extends CreatingAnnouncementState {}

class CreatingSuccessState extends CreatingAnnouncementState {}

class CreatingLoadingState extends CreatingAnnouncementState {}

class CreatingFailState extends CreatingAnnouncementState {
  final String error;

  CreatingFailState(this.error);
}
