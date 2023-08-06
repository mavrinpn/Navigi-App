import 'package:bloc/bloc.dart';

import '../../../../managers/search_manager.dart';
import '../../../../models/item/item.dart';

part 'search_announcements_state.dart';

class SearchItemsCubit extends Cubit<SearchItemsState> {
  final SearchManager searchManager;

  SearchItemsCubit({required this.searchManager})
      : super(SearchItemsWait());

  void search(String query) async {
    if (query.isEmpty) {
      emit(SearchItemsWait());
    } else {
      emit(SearchItemsLoading());
      try {
        final result = await searchManager.searchItemsByName(query);

        emit(SearchItemsSuccess(result: result));
      } catch (e) {
        emit(SearchItemsFail());
        rethrow;
      }
    }
  }
}
