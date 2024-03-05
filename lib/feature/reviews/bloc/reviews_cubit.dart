import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart/managers/reviews_manager.dart';
import 'package:smart/models/review.dart';

part 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final ReviewsManager _reviewsManager;

  ReviewsCubit({
    required ReviewsManager reviewsManager,
  })  : _reviewsManager = reviewsManager,
        super(ReviewsInitial());

  void loadBy({
    required String receiverId,
  }) async {
    emit(ReviewsLoadingState());
    try {
      final result = await _reviewsManager.loadBy(receiverId);

      emit(ReviewsSuccessState(reviews: result));
    } catch (err) {
      emit(ReviewsFailState());
      rethrow;
    }
  }

  void addReview({
    required int score,
    required String text,
    required String receiverId,
  }) async {
    emit(ReviewSavingState());
    try {
      await _reviewsManager.newReview(
        receiverId: receiverId,
        score: score,
        text: text,
      );

      emit(ReviewSuccessSavedState());
    } catch (err) {
      emit(ReviewSaveFailState(message: err.toString()));
      rethrow;
    }
  }
}
