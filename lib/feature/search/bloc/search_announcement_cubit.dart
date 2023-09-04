import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../managers/announcement_manager.dart';

part 'search_announcement_state.dart';

class SearchAnnouncementCubit extends Cubit<SearchAnnouncementState> {
  final AnnouncementManager _announcementManager;

  String? _sortBy;

  void setSortType(String? searchType) => _sortBy = searchType;

  void clearSortType() => _sortBy = null;

  SearchAnnouncementCubit({required AnnouncementManager announcementManager})
      : _announcementManager = announcementManager,
        super(SearchAnnouncementInitial());

  void searchAnnounces(String? searchText, bool isNew) async {
    emit(SearchAnnouncementsLoadingState());
    try {
      await _announcementManager.loadSearchAnnouncement(
          searchText: searchText, isNew: isNew, sortBy: _sortBy);
      emit(SearchAnnouncementsSuccessState());
    } catch (e) {
      emit(SearchAnnouncementsFailState());
      rethrow;
    }
  }
}
