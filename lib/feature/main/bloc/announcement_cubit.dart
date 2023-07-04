import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'announcement_manager.dart';

part 'announcement_state.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  final AnnouncementManager _announcementManager;

  AnnouncementCubit({required AnnouncementManager announcementManager})
      : _announcementManager = announcementManager,
        super(AnnouncementInitial()) {
    loadAnnounces();
  }

  void loadAnnounces() async {
    emit(AnnouncementsLoadingState());
    try {
      await _announcementManager.getAnnouncements();
      await Future.delayed(const Duration(seconds: 5));
      emit(AnnouncementsSuccessState());
    } catch (e) {
      emit(AnnouncementsFailState());
      rethrow;
    }
  }
}
