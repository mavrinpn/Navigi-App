import 'package:bloc/bloc.dart';
import 'package:smart/models/announcement.dart';

import '../../../../managers/announcement_manager.dart';


part 'announcement_state.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  final AnnouncementManager _announcementManager;

  AnnouncementCubit({required AnnouncementManager announcementManager})
      : _announcementManager = announcementManager,
        super(AnnouncementInitial());

  void loadAnnouncementById(String id) async {
    emit(AnnouncementLoadingState());
    try {
      final data = await _announcementManager.getAnnouncementById(id);
      emit(AnnouncementSuccessState(data: data!));
    } catch (e) {
      emit(AnnouncementFailState());
      rethrow;
    }
  }
}
