part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {}

class AuthFailState extends AuthState {}

class AuthErrorInvalidCode extends AuthState {}

class AuthUserNotVerificated extends AuthState {}

class UserAlreadyExistState extends AuthState {}

class NotFoundState extends AuthState {}

class CodeSentState extends AuthState {}

class UserCreatingState extends AuthState {}

class UserSuccessCreatedState extends AuthState {}
