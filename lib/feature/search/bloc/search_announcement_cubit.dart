import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../managers/announcement_manager.dart';

part 'search_announcement_state.dart';

class SearchAnnouncementCubit extends Cubit<SearchAnnouncementState> {
  final AnnouncementManager _announcementManager;

  SearchAnnouncementCubit({required AnnouncementManager announcementManager})
      : _announcementManager = announcementManager,
        super(SearchAnnouncementInitial());

  void searchAnnounces(String? searchText, bool isNew) async {
    emit(SearchAnnouncementsLoadingState());
    try {
      await _announcementManager.loadSearchAnnouncement(searchText, isNew);
      emit(SearchAnnouncementsSuccessState());
    } catch (e) {
      emit(SearchAnnouncementsFailState());
      rethrow;
    }
  }
}
