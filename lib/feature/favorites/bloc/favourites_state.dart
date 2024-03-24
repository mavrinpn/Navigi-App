part of 'favourites_cubit.dart';

@immutable
abstract class FavouritesState extends Equatable {}

class FavouritesInitial extends FavouritesState {
  @override
  List<Object?> get props => [];
}

class FavouritesLoadingState extends FavouritesState {
  @override
  List<Object?> get props => [];
}

class FavouritesSuccessState extends FavouritesState {
  @override
  List<Object?> get props => [];
}

class FavouritesFailState extends FavouritesState {
  @override
  List<Object?> get props => [];
}

class LikeProcessState extends FavouritesState {
  @override
  List<Object?> get props => [];
}

class LikesCountSuccessState extends FavouritesState {
  final int count;
  final String postId;

  LikesCountSuccessState({
    required this.count,
    required this.postId,
  });

  @override
  List<Object?> get props => [count, postId];
}

class LikesCountFailState extends FavouritesState {
  @override
  List<Object?> get props => [];
}

class LikeSuccessState extends FavouritesState {
  final String changedPostId;
  final bool value;

  LikeSuccessState({required this.value, required this.changedPostId});

  @override
  String toString() => 'LikeSuccessState for $changedPostId: isLiked = $value';

  @override
  List<Object?> get props => [changedPostId, value];
}

class LikeFailState extends FavouritesState {
  @override
  List<Object?> get props => [];
}
