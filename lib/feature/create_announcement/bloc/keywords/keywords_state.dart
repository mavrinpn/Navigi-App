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
  final List<KeyWord> keywords;
  final String currentQuery;

  KeyWordssSuccessState({
    required this.keywords,
    required this.currentQuery,
  });
  @override
  List<Object?> get props => [keywords, currentQuery];
}

class KeyWordssFailState extends KeyWordsState {
  @override
  List<Object?> get props => [];
}
