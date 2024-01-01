import 'package:smart/services/database/database_service.dart';

import '../../models/item/item.dart';

class ItemManager {
  final DatabaseService databaseService;

  ItemManager({required this.databaseService});

  List<SubCategoryItem> items = [];
  List<SubCategoryItem> searchedItems = [];
  String searchController = '';

  Future initialLoadItems(String query, subcategoryId) async =>
      items = await databaseService.categories.getItemsFromSubcategory(subcategoryId);

  void searchItemsByName(String query) {
    List<SubCategoryItem> resList = [];
    for (var item in items) {
      if (item.name.toLowerCase().contains(query.toLowerCase())) {
        resList.add(item);
      }
    }
    searchedItems = resList;
  }

  void clearSearchItems() {
    searchedItems.clear();
  }

  void setSearchController(String value) {
    searchController = value;
  }

  SubCategoryItem? hasItemInSearchedItems() {
    for (var item in searchedItems) {
      if (searchController == item.name) {
        return item;
      }
    }
    return null;
  }
}
