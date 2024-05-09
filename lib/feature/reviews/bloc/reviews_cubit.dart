import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/main.dart';
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
      final status = await _reviewsManager.newReview(
        receiverId: receiverId,
        score: score,
        text: text,
      );

      if (status == 'ok') {
        emit(ReviewSuccessSavedState());
      } else {
        final locale = Locale(currentLocaleShortName.value);
        AppLocalizations localizations = await AppLocalizations.delegate.load(locale);
        String message = '';
        switch (status) {
          case 'error_comment_already_left':
            message = localizations.errorCommentAlreadyLeft;
            break;
          case 'error_comment_yourself':
            message = localizations.errorCommentYourself;
            break;
          case 'error_invalid_score':
            message = localizations.errorInvalidScore;
            break;
          case 'error_text':
            message = localizations.errorText;
            break;
          default:
        }

        emit(ReviewSaveFailState(message: message));
      }
    } catch (err) {
      emit(ReviewSaveFailState(message: err.toString()));
      rethrow;
    }
  }
}
