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
  final String currentQuery;

  TipWordssSuccessState({
    required this.tipWords,
    required this.currentQuery,
  });
  @override
  List<Object?> get props => [tipWords, currentQuery];
}

class TipWordssFailState extends TipWordsState {
  @override
  List<Object?> get props => [];
}
