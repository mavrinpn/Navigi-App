import 'package:bloc/bloc.dart';
import 'package:smart/models/item/subcategory_filters.dart';
import 'package:smart/utils/constants.dart';

import '../../../../managers/creating_announcement_manager.dart';
import '../../../../managers/item_manager.dart';
import '../../../../models/item/item.dart';

part 'item_search_state.dart';

class ItemSearchCubit extends Cubit<ItemSearchState> {
  final CreatingAnnouncementManager creatingManager;
  final ItemManager itemManager;

  ItemSearchCubit({required this.creatingManager, required this.itemManager})
      : super(ItemSearchInitial());

  List<SubcategoryItem> getItems() => itemManager.searchedItems;

  Future<SubcategoryFilters> getSubcategoryFilters(String subcategory) async {
    final parameters = await itemManager.getSubcategoryFilters(subcategory);
    creatingManager.subcategoryFilters = parameters;
    return parameters;
  }

  Future<(List<Parameter>, SubcategoryFilters)>
      getSubcategoryAndModelParameters({
    required String subcategory,
    required String modelId,
  }) async {
    final List<Parameter> parameters = [];

    if (subcategory == carSubcategoryId) {
      final carFilter = await itemManager.getCarFilters(modelId);
      parameters.add(carFilter.dotation);
      parameters.add(carFilter.engine);
    } else {
      final marksFilter = await itemManager.getMarksFilters(modelId);
      if (marksFilter != null && marksFilter.modelParameters != null) {
        parameters.addAll(marksFilter.modelParameters!);
      }
    }

    final subcategoryFilters =
        await itemManager.getSubcategoryFilters(subcategory);
    parameters.addAll(subcategoryFilters.parameters);

    return (parameters, subcategoryFilters);
  }

  void setSubcategory(String subcategory) async {
    emit(SearchLoadingState());
    try {
      creatingManager.setSubcategory(subcategory);
      itemManager.initialLoadItems('', subcategory);
      itemManager.clearSearchItems();
      emit(SearchEmptyState());
    } catch (e) {
      emit(SearchFailState());
      rethrow;
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
