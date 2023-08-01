import 'package:bloc/bloc.dart';

import '../../../../managers/announcement_manager.dart';
import '../../../../models/announcement.dart';

part 'search_announcements_state.dart';

class SearchAnnouncementsCubit extends Cubit<SearchAnnouncementsState> {
  final AnnouncementManager announcementManager;

  SearchAnnouncementsCubit({required this.announcementManager})
      : super(WaitSearch());

  void search(String query) async {
    if (query.isEmpty) {
      emit(WaitSearch());
    } else {
      try {
        emit(LoadingSearch());
        final result = await announcementManager.searchAnnouncements(query);
        emit(SuccessSearch(result: result));
      } catch (e) {
        emit(FailSearch());
        rethrow;
      }
    }
  }
}
