import 'package:bloc/bloc.dart';

import '../../../../managers/creating_announcement_manager.dart';
import '../../../../managers/item_manager.dart';
import '../../../../models/item/item.dart';

part 'item_search_state.dart';

class ItemSearchCubit extends Cubit<ItemSearchState> {
  final CreatingAnnouncementManager creatingManager;
  final ItemManager itemManager;

  ItemSearchCubit({required this.creatingManager, required this.itemManager})
      : super(ItemSearchInitial());

  List<SubCategoryItem> getItems() => itemManager.searchedItems;

  void setSubcategory(String subcategory) {
    emit(SearchLoadingState());
    try {
      creatingManager.setSubcategory(subcategory);
      itemManager.initialLoadItems('', subcategory);
      itemManager.clearSearchItems();
      emit(SearchEmptyState());
    } catch (e) {
      emit(SearchFailState());
    }
  }

  void setItemName(String name) => itemManager.setSearchController(name);

  void searchItems(String query) {
    emit(SearchLoadingState());
    itemManager.searchControllerText = query;

    if (query.isEmpty) {
      itemManager.clearSearchItems();
      emit(SearchEmptyState());
      return;
    }

    itemManager.searchItemsByName(query);
    emit(SearchSuccessState());
  }

  String getSearchText() => itemManager.searchControllerText;
}
