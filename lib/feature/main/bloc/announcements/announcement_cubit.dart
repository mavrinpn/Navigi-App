import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart/enum/enum.dart';

import '../../../../managers/announcement_manager.dart';


part 'announcement_state.dart';

class AnnouncementsCubit extends Cubit<AnnouncementsState> {
  final AnnouncementManager _announcementManager;

  AnnouncementsCubit({required AnnouncementManager announcementManager})
      : _announcementManager = announcementManager,
        super(AnnouncementInitial()) {
    //loadAnnounces(true);
    announcementManager.announcementsLoadingState.stream.listen((event) {
      if (event == LoadingStateEnum.loading) emit(AnnouncementsLoadingState());
      if (event == LoadingStateEnum.success) emit(AnnouncementsSuccessState());
    });
  }

  void loadAnnounces(bool isNew) async {
    //emit(AnnouncementsLoadingState());
    try {
      await _announcementManager.addLimitAnnouncements(isNew);
      //emit(AnnouncementsSuccessState());
    } catch (e) {
      emit(AnnouncementsFailState());
      rethrow;
    }
  }
}
