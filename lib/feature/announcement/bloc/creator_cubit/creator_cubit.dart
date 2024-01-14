import 'package:bloc/bloc.dart';
import 'package:smart/models/announcement.dart';

import '../../../../models/user.dart';
import '../../data/creator_repository.dart';

part 'creator_state.dart';

class CreatorCubit extends Cubit<CreatorState> {
  final CreatorRepository creatorRepository;

  CreatorCubit({required this.creatorRepository}) : super(CreatorInitial());

  void setUserId(String creatorId) async {
    emit(CreatorLoadingState());
    try {
      await creatorRepository.setCreator(creatorId);
      emit(CreatorSuccessState(
          available: creatorRepository.availableAnnouncements,
          sold: creatorRepository.soldAnnouncements));
    } catch (e) {
      emit(CreatorFailState());
      rethrow;
    }
  }

  void setUserData(UserData userData) async {
    emit(CreatorLoadingState());
    try {
      creatorRepository.setUserData(userData);
      emit((CreatorSuccessState(
          available: creatorRepository.availableAnnouncements,
          sold: creatorRepository.soldAnnouncements)));
    } catch (e) {
      emit(CreatorFailState());
      rethrow;
    }
  }
}
