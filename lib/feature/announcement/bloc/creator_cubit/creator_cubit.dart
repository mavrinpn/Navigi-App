import 'package:bloc/bloc.dart';
import 'package:smart/feature/auth/data/auth_repository.dart';
import 'package:smart/models/announcement.dart';

import '../../../../models/user.dart';
import '../../data/creator_repository.dart';

part 'creator_state.dart';

class CreatorCubit extends Cubit<CreatorState> {
  final CreatorRepository creatorRepository;
  final AuthRepository authRepository;

  CreatorCubit({
    required this.creatorRepository,
    required this.authRepository,
  }) : super(CreatorInitial());

  Future<void> setUserData({
    required String creatorId,
    required UserData? userData,
  }) async {
    emit(CreatorLoadingState());
    try {
      if (userData != null) {
        creatorRepository.setUserData(userData);
      } else {
        final UserData? userData = await authRepository.getUserDataById(creatorId);
        if (userData != null) {
          creatorRepository.setUserData(userData);
        } else {
          emit(CreatorFailState());
          return;
        }
      }
      await creatorRepository.setCreator(creatorId);
      emit(CreatorSuccessState(
        available: creatorRepository.availableAnnouncements,
        sold: creatorRepository.soldAnnouncements,
      ));
    } catch (e) {
      emit(CreatorFailState());
      rethrow;
    }
  }

  void setUserId(String creatorId) async {
    emit(CreatorLoadingState());
    try {
      await creatorRepository.setCreator(creatorId);
      emit(CreatorSuccessState(
        available: creatorRepository.availableAnnouncements,
        sold: creatorRepository.soldAnnouncements,
      ));
    } catch (e) {
      emit(CreatorFailState());
      rethrow;
    }
  }

  // void setUserData(UserData userData) async {
  //   emit(CreatorLoadingState());
  //   try {
  //     creatorRepository.setUserData(userData);
  //     emit((CreatorSuccessState(
  //         available: creatorRepository.availableAnnouncements,
  //         sold: creatorRepository.soldAnnouncements)));
  //   } catch (e) {
  //     emit(CreatorFailState());
  //     rethrow;
  //   }
  // }
}
