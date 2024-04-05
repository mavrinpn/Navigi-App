part of 'keywords_cubit.dart';

abstract class KeyWordsState extends Equatable {}

class KeyWordsInitial extends KeyWordsState {
  @override
  List<Object?> get props => [];
}

class KeyWordssLoadingState extends KeyWordsState {
  @override
  List<Object?> get props => [];
}

class KeyWordssSuccessState extends KeyWordsState {
  final List<KeyWord> keyWordsFr;
  final List<KeyWord> keyWordsAr;

  KeyWordssSuccessState({
    required this.keyWordsFr,
    required this.keyWordsAr,
  });
  @override
  List<Object?> get props => [keyWordsFr, keyWordsAr];
}

class KeyWordssFailState extends KeyWordsState {
  @override
  List<Object?> get props => [];
}
