part of 'creator_cubit.dart';

@immutable
abstract class CreatorState {}

class CreatorInitial extends CreatorState {}

class CreatorLoadingState extends CreatorState {}

class CreatorSuccessState extends CreatorState {}

class CreatorFailState extends CreatorState {}
