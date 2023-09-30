part of 'creator_cubit.dart';

@immutable
abstract class CreatorState {}

class CreatorInitial extends CreatorState {}

class CreatorLoadingState extends CreatorState {}

class CreatorSuccessState extends CreatorState {
  List<Announcement> available;
  List<Announcement> sold;

  CreatorSuccessState({required this.available, required this.sold});
}

class CreatorFailState extends CreatorState {}

class CreatorUser extends CreatorState {}
