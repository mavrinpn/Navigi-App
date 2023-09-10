import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart/enum/enum.dart';

import '../../../managers/favourits_manager.dart';

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

  Future<bool> like(String postId) async {
    emit(LikeProcessState());
    try {
      await favouritesManager.like(postId);
      emit(LikeSuccessState());
      return true;
    } catch (e) {
      emit(LikeFailState());
      return false;
    }
  }

  Future<bool> unlike(String postId) async {
    emit(LikeProcessState());
    try {
      await favouritesManager.unlike(postId);
      emit(LikeSuccessState());
      return true;
    } catch (e) {
      emit(LikeFailState());
      return false;
    }
  }
}
