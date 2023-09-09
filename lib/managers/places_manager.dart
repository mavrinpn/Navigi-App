import 'package:smart/models/announcement.dart';

import '../services/database_service.dart';

class PlacesManager {
  final DatabaseService databaseManager;

  PlacesManager({required this.databaseManager});

  List<PlaceData> _places = [];
  List<PlaceData> searchedPlaces = [];
  String searchController = '';

  Future initialLoadItems() async =>
      _places = await databaseManager.getAllPlaces();

  void searchPlacesByName(String query) {
    List<PlaceData> resList = [];
    for (var item in _places) {
      if (item.name.toLowerCase().contains(query.toLowerCase().trimLeft())) {
        resList.add(item);
      }
    }
    searchedPlaces = resList;
  }

  String? searchPlaceIdByName(value){
    for(var item in _places){
      if(item.name == value){
        return item.id;
      }
    }
    return null;
  }

  void clearSearchItems() {
    searchedPlaces.clear();
  }

  void setSearchController(String value) {
    searchController = value;
  }

}
