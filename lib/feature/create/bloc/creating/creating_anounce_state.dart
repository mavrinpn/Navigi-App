part of 'creating_anounce_cubit.dart';

@immutable
abstract class CreatingAnounceState {}

class CreatingAnounceInitial extends CreatingAnounceState {}

class CreatingSuccessState extends CreatingAnounceState {}

class CreatingLoadingState extends CreatingAnounceState {}

class CreatingFailState extends CreatingAnounceState {}
