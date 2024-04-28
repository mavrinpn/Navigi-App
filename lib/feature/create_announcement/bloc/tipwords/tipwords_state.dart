part of 'tipwords_cubit.dart';

abstract class TipWordsState extends Equatable {}

class TipWordsInitial extends TipWordsState {
  @override
  List<Object?> get props => [];
}

class TipWordssLoadingState extends TipWordsState {
  @override
  List<Object?> get props => [];
}

class TipWordssSuccessState extends TipWordsState {
  final List<TipWord> tipWords;
  final String lastWord;
  final String wholeString;

  TipWordssSuccessState({
    required this.tipWords,
    required this.lastWord,
    required this.wholeString,
  });
  @override
  List<Object?> get props => [tipWords, lastWord, wholeString];
}

class TipWordssFailState extends TipWordsState {
  @override
  List<Object?> get props => [];
}
