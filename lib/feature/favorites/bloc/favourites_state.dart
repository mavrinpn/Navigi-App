part of 'favourites_cubit.dart';

@immutable
abstract class FavouritesState {}

class FavouritesInitial extends FavouritesState {}

class FavouritesLoadingState extends FavouritesState {}

class FavouritesSuccessState extends FavouritesState {}

class FavouritesFailState extends FavouritesState {}

class LikeProcessState extends FavouritesState {}

class LikeSuccessState extends FavouritesState {}

class LikeFailState extends FavouritesState {}
