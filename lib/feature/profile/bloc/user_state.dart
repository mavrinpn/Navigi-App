part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class ProfileLoadingState extends UserState {}

class ProfileSuccessState extends UserState {}

class EditSuccessState extends UserState {}

class EditFailState extends UserState {}

class ProfileFailState extends UserState {}
