import 'package:bloc/bloc.dart';

import '../../../../managers/search_manager.dart';
import '../../../../models/item/item.dart';

part 'search_announcements_state.dart';

class SearchAnnouncementsCubit extends Cubit<SearchAnnouncementsState> {
  final SearchManager searchManager;

  SearchAnnouncementsCubit({required this.searchManager})
      : super(SearchWait());

  void search(String query) async {
    if (query.isEmpty) {
      emit(SearchWait());
    } else {
      emit(SearchLoading());
      try {
        final result = await searchManager.searchItemsByName(query);

        emit(SearchSuccess(result: result));
      } catch (e) {
        emit(SearchFail());
        rethrow;
      }
    }
  }
}
