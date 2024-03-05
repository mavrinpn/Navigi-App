part of 'reviews_cubit.dart';

abstract class ReviewsState extends Equatable {}

class ReviewsInitial extends ReviewsState {
  @override
  List<Object?> get props => [];
}

class ReviewsLoadingState extends ReviewsState {
  @override
  List<Object?> get props => [];
}

class ReviewsSuccessState extends ReviewsState {
  final List<Review> reviews;

  ReviewsSuccessState({required this.reviews});
  @override
  List<Object?> get props => [reviews];
}

class ReviewsFailState extends ReviewsState {
  @override
  List<Object?> get props => [];
}

class ReviewSavingState extends ReviewsState {
  @override
  List<Object?> get props => [];
}

class ReviewSuccessSavedState extends ReviewsState {
  ReviewSuccessSavedState();
  @override
  List<Object?> get props => [];
}

class ReviewSaveFailState extends ReviewsState {
  final String message;

  ReviewSaveFailState({required this.message});

  @override
  List<Object?> get props => [message];
}
