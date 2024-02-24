import 'package:smart/models/item/subcategoryFilters.dart';
import 'package:smart/services/database/database_service.dart';
import 'package:smart/services/parameters_parser.dart';

import '../../models/item/item.dart';

class ItemManager {
  final DatabaseService databaseService;

  ItemManager({required this.databaseService});

  List<SubcategoryItem> items = [];
  List<SubcategoryItem> searchedItems = [];
  String searchControllerText = '';

  Future<SubcategoryFilters> getSubcategoryFilters(String subcategoryId) async {
    final res = await databaseService.categories
        .getSubcategoryParameters(subcategoryId);
    final parameters = res['parameters'];
    print(parameters);
    final decodedFilters = ParametersParser(parameters).decodedParameters;
    return SubcategoryFilters(decodedFilters,
        hasMark: res['hasMark'], hasModel: res['hasModel']);
  }

  Future initialLoadItems(String query, subcategoryId) async {
    items =
        await databaseService.categories.getItemsFromSubcategory(subcategoryId);
  }

  void searchItemsByName(String query) {
    List<SubcategoryItem> resList = [];
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
    searchControllerText = value;
  }

  SubcategoryItem? hasItemInSearchedItems() {
    for (var item in searchedItems) {
      if (searchControllerText == item.name) {
        return item;
      }
    }
    return null;
  }
}
