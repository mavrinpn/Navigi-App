import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:smart/feature/create/data/creting_manager.dart';

import '../../../../data/app_repository.dart';
import '../../../../models/item.dart';

part 'item_search_state.dart';

class ItemSearchCubit extends Cubit<ItemSearchState> {
  final CreatingManager creatingManager;
  String currentSubcategory = '';

  ItemSearchCubit({required this.creatingManager})
      : super(ItemSearchInitial()) {
    creatingManager.searchState.stream.listen((event) {
      if (event == LoadingStateEnum.loading) emit(SearchLoadingState());
      if (event == LoadingStateEnum.fail) emit(SearchFailState());
      if (event == LoadingStateEnum.success) {
        if (creatingManager.items.isNotEmpty) {
          emit(SearchSuccessState(items: creatingManager.items));
        } else {
          emit(SearchEmptyState());
        }
      }
    });
  }

  void setSubcategory(String subcategory) {
    currentSubcategory = subcategory;

    creatingManager.initialLoadItems('', currentSubcategory);
    creatingManager.clearSearchItems();

    emit(SearchEmptyState());
  }

  void searchItems(String query) {
    if(query.isEmpty){
      creatingManager.clearSearchItems();
      emit(SearchEmptyState());
      return;
    }

    creatingManager.searchItemsByName(query);
  }
}
