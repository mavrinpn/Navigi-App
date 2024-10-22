part of 'app_cubit.dart';

@immutable
abstract class AppState extends Equatable {}

class AppInitial extends AppState {
  @override
  List<Object?> get props => [];
}

class AppAuthState extends AppState {
  @override
  List<Object?> get props => [];
}

class AppUnAuthState extends AppState {
  @override
  List<Object?> get props => [];
}

class AppAuthWithNoDataState extends AppState {
  @override
  List<Object?> get props => [];
}
