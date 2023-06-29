import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:smart/feature/create/data/creting_announcement_manager.dart';

import '../../../../data/app_repository.dart';
import '../../../../models/item.dart';
import '../../data/item_manager.dart';

part 'item_search_state.dart';

class ItemSearchCubit extends Cubit<ItemSearchState> {
  final CreatingAnnouncementManager creatingManager;
  final ItemManager itemManager;

  ItemSearchCubit({required this.creatingManager, required this.itemManager})
      : super(ItemSearchInitial()) {
    itemManager.searchState.stream.listen((event) {
      if (event == LoadingStateEnum.loading) emit(SearchLoadingState());
      if (event == LoadingStateEnum.fail) emit(SearchFailState());
      if (event == LoadingStateEnum.success) {
        if (itemManager.searchItems.isNotEmpty) {
          emit(SearchSuccessState());
        } else {
          emit(SearchEmptyState());
        }
      }
    });
  }

  List<SubCategoryItem> getItems() => itemManager.searchItems;

  void setSubcategory(String subcategory) {
    itemManager.searchController = '';
    itemManager.initialLoadItems('', subcategory);
    itemManager.clearSearchItems();

    emit(SearchEmptyState());
  }

  void setItemName(String name) => itemManager.setSearchController(name);

  void searchItems(String query) {
    itemManager.searchController = query;

    if(query.isEmpty){
      itemManager.clearSearchItems();
      emit(SearchEmptyState());
      return;
    }

    itemManager.searchItemsByName(query);
  }

  String getSearchText() => itemManager.searchController;
}
