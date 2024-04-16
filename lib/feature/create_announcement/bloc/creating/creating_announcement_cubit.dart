import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../enum/enum.dart';
import '../../../../managers/creating_announcement_manager.dart';

part 'creating_announcement_state.dart';

String creatingAnnouncementError = '';

class CreatingAnnouncementCubit extends Cubit<CreatingAnnouncementState> {
  CreatingAnnouncementManager creatingAnnouncementManager;

  CreatingAnnouncementCubit({required this.creatingAnnouncementManager}) : super(CreatingAnnouncementInitial()) {
    creatingAnnouncementManager.creatingState.stream.listen((event) {
      if (event == LoadingStateEnum.loading) emit(CreatingLoadingState());
      if (event == LoadingStateEnum.success) {
        creatingAnnouncementManager.images = [];
        //creatingAnnouncementManager.imagesAsBytes = [];
        emit(CreatingSuccessState());
      }
      if (event == LoadingStateEnum.fail) {
        emit(CreatingFailState(creatingAnnouncementError));
      }
    });
  }

  createAnnouncement() => creatingAnnouncementManager.createAnnouncement();
}
