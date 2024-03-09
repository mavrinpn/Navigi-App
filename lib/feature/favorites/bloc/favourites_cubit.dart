import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart/enum/enum.dart';

import '../../../managers/favourites_manager.dart';

part 'favourites_state.dart';

class FavouritesCubit extends Cubit<FavouritesState> {
  FavouritesManager favouritesManager;

  FavouritesCubit({required this.favouritesManager})
      : super(FavouritesInitial()) {
    favouritesManager.loadingState.stream.listen((event) {
      if (event == LoadingStateEnum.loading) emit(FavouritesLoadingState());
      if (event == LoadingStateEnum.success) emit(FavouritesSuccessState());
      if (event == LoadingStateEnum.fail) emit(FavouritesFailState());
    });
  }

  bool isLiked(String id) => favouritesManager.contains(id);

  Future<bool> likeUnlike(String postId) async {
    emit(LikeProcessState());
    try {
      if (isLiked(postId)) {
        await favouritesManager.unlike(postId);
        emit(LikeSuccessState(changedPostId: postId, value: false));
      } else {
        await favouritesManager.like(postId);
        emit(LikeSuccessState(changedPostId: postId, value: true));
      }

      await favouritesManager.getFavourites();
      return true;
    } catch (e) {
      emit(LikeFailState());
      rethrow;
    }
  }
}
