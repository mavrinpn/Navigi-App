import 'package:smart/models/announcement.dart';

import '../../../models/item.dart';
import '../../../services/database_manager.dart';

class PlacesManager {
  final DatabaseManger databaseManager;

  PlacesManager({required this.databaseManager});

  List<PlaceData> places = [];
  List<PlaceData> searchedPlaces = [];
  String searchController = '';

  Future initialLoadItems() async =>
      places = await databaseManager.getAllPlaces();

  void searchPlacesByName(String query) {
    List<PlaceData> resList = [];
    for (var item in places) {
      if (item.name.toLowerCase().contains(query.toLowerCase())) {
        resList.add(item);
      }
    }
    searchedPlaces = resList;
  }

  void clearSearchItems() {
    searchedPlaces.clear();
  }

  void setSearchController(String value) {
    searchController = value;
  }

  PlaceData? hasItemInSearchedItems() {
    for (var item in searchedPlaces) {
      if (searchController == item.name) {
        return item;
      }
    }
    return null;
  }

  String? searchPlaceIdByName(value){
    for(var item in places){
      print('${item.name} $value == ${item.name == value}');
      if(item.name == value){
        print(item.id);
        return item.id;
      }
    }

    return null;
  }
}
