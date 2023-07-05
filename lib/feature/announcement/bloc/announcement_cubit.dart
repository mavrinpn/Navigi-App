import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../main/bloc/announcement_manager.dart';

part 'announcement_state.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  final AnnouncementManager _announcementManager;

  AnnouncementCubit({required AnnouncementManager announcementManager})
      : _announcementManager = announcementManager,
        super(AnnouncementInitial());

  void loadAnnouncementById(String id) async {
    emit(AnnouncementsLoadingState());
    try {
      await _announcementManager.getAnnouncementById(id);
      emit(AnnouncementsSuccessState());
    } catch (e) {
      emit(AnnouncementsFailState());
      rethrow;
    }
  }
}
