import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart/models/announcement.dart';

import '../../data/creator_repository.dart';

part 'creator_state.dart';

class CreatorCubit extends Cubit<CreatorState> {
  final CreatorRepository creatorRepository;

  CreatorCubit({required this.creatorRepository}) : super(CreatorInitial());

  void setUser(CreatorData creatorData) async {
    emit(CreatorLoadingState());
    try {
      await creatorRepository.setCreator(creatorData);

      emit(CreatorSuccessState());
    } catch (e) {
      emit(CreatorFailState());
    }
  }
}
