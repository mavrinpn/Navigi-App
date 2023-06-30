import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart/data/app_repository.dart';

import '../../data/creting_announcement_manager.dart';

part 'creating_anounce_state.dart';

class CreatingAnounceCubit extends Cubit<CreatingAnounceState> {
  CreatingAnnouncementManager creatingAnnouncementManager;

  CreatingAnounceCubit({required this.creatingAnnouncementManager}) : super(CreatingAnounceInitial()) {
    creatingAnnouncementManager.creatingState.stream.listen((event) {
      if (event == LoadingStateEnum.loading) emit(CreatingLoadingState());
      if (event == LoadingStateEnum.success) emit(CreatingSuccessState());
      if (event == LoadingStateEnum.fail) emit(CreatingFailState());
    });
  }

  createAnounce() => creatingAnnouncementManager.createAnounce();
}
