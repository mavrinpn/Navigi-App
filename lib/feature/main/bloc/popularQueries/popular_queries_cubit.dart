import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../managers/search_manager.dart';

part 'popular_queries_state.dart';

class PopularQueriesCubit extends Cubit<PopularQueriesState> {
  final SearchManager searchManager;

  PopularQueriesCubit({required this.searchManager})
      : super(PopularQueriesInitial());

  void loadPopularQueries() async{
    emit(PopularQueriesLoading());
    try {
      await searchManager.loadPopularQueries();
      emit(PopularQueriesSuccess());
    } catch (e) {
      emit(PopularQueriesFail());
      rethrow;
    }
  }
}
