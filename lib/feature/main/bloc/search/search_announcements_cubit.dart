import 'package:bloc/bloc.dart';
import 'package:smart/models/key_word.dart';

import '../../../../managers/search_manager.dart';

part 'search_announcements_state.dart';

class SearchItemsCubit extends Cubit<SearchItemsState> {
  final SearchManager searchManager;

  SearchItemsCubit({required this.searchManager}) : super(SearchItemsWait());

  void searchKeywords({
    required String query,
    required String? subcategoryId,
  }) async {
    if (query.isEmpty) {
      emit(SearchItemsWait());
    } else {
      emit(SearchItemsLoading());
      try {
        final result = await searchManager.getKeyWords(
          name: query,
          subcategoryId: subcategoryId,
        );

        emit(SearchItemsSuccess(
          result: result,
          currentQuery: query,
        ));
      } catch (e) {
        emit(SearchItemsFail());
        rethrow;
      }
    }
  }
}
