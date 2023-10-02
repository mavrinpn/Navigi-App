part of 'favourites_cubit.dart';

@immutable
abstract class FavouritesState {}

class FavouritesInitial extends FavouritesState {}

class FavouritesLoadingState extends FavouritesState {}

class FavouritesSuccessState extends FavouritesState {}

class FavouritesFailState extends FavouritesState {}

class LikeProcessState extends FavouritesState {}

class LikeSuccessState extends FavouritesState {
  final String changedPostId;
  final bool value;

  LikeSuccessState({required this.value, required this.changedPostId});

  @override
  String toString() => 'LikeSuccessState for $changedPostId: isLiked = $value';
}

class LikeFailState extends FavouritesState {}
