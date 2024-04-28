import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart/managers/tipwords_manager.dart';
import 'package:smart/models/tip_word.dart';

part 'tipwords_state.dart';

class TipWordsCubit extends Cubit<TipWordsState> {
  final TipWordsManager _tipWordsManager;

  TipWordsCubit({
    required TipWordsManager tipWordsManager,
  })  : _tipWordsManager = tipWordsManager,
        super(TipWordsInitial());

  void getTipWordsBy({
    required String subcategoryId,
    required String? lastWord,
    required String? wholeString,
    required String? markId,
    required String? modelId,
    required String? previousWordId,
    required String? previousWordGroupId,
  }) async {
    emit(TipWordssLoadingState());

    if (lastWord == '' && wholeString == '') {
      emit(TipWordssSuccessState(
        tipWords: const [],
        lastWord: '',
        wholeString: '',
      ));
      return;
    }
    try {
      final results = await _tipWordsManager.searchBy(
        subcategoryId: subcategoryId,
        lastWord: lastWord,
        wholeString: wholeString,
        markId: markId,
        modelId: modelId,
        previousWordId: previousWordId,
        previousWordGroupId: previousWordGroupId,
      );

      emit(TipWordssSuccessState(
        tipWords: results,
        lastWord: lastWord ?? '',
        wholeString: wholeString ?? '',
      ));
    } catch (e) {
      emit(TipWordssFailState());
      rethrow;
    }
  }
}
