import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart/managers/keywords_manager.dart';
import 'package:smart/models/key_word.dart';

part 'keywords_state.dart';

class KeyWordsCubit extends Cubit<KeyWordsState> {
  final KeyWordsManager _keyWordsManager;

  KeyWordsCubit({
    required KeyWordsManager keyWordsManager,
  })  : _keyWordsManager = keyWordsManager,
        super(KeyWordsInitial());

  void getKeywordsBy({
    required String subcategoryId,
    required String query,
  }) async {
    emit(KeyWordssLoadingState());

    if (query == '') {
      emit(KeyWordssSuccessState(
        keywords: const [],
        currentQuery: query,
        // keyWordsFr: const [],
        // keyWordsAr: const [],
      ));
      return;
    }
    try {
      final results = await _keyWordsManager.searchBy(
        subcategoryId: subcategoryId,
        query: query,
      );
      // final resFr = await _keyWordsManager.searchByFr(
      //   subcategoryId: subcategoryId,
      //   query: query,
      // );
      // final resAr = await _keyWordsManager.searchByAr(
      //   subcategoryId: subcategoryId,
      //   query: query,
      // );

      emit(KeyWordssSuccessState(
        keywords: results,
        currentQuery: query,
        // keyWordsFr: resFr,
        // keyWordsAr: resAr,
      ));
    } catch (e) {
      emit(KeyWordssFailState());
      rethrow;
    }
  }
}
