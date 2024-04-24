part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {}

class AuthFailState extends AuthState {}

class AlreadyExistState extends AuthState {}

class NotFoundState extends AuthState {}

class CodeSentState extends AuthState {}
