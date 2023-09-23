import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart/models/announcement.dart';

import '../../data/creator_repository.dart';

part 'creator_state.dart';

class CreatorCubit extends Cubit<CreatorState> {
  final CreatorRepository creatorRepository;

  CreatorCubit({required this.creatorRepository}) : super(CreatorInitial());

  void setUser(String creatorId) async {
    emit(CreatorLoadingState());
    try {
      await creatorRepository.setCreator(creatorId);

      emit(CreatorSuccessState());
    } catch (e) {
      emit(CreatorFailState());
      rethrow;
    }
  }
}
