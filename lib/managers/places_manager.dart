import 'package:smart/models/announcement.dart';
import 'package:smart/models/city.dart';
import 'package:smart/services/database/database_service.dart';

class PlacesManager {
  final DatabaseService databaseService;

  PlacesManager({required this.databaseService});

  List<CityDistrict> _places = [];
  List<CityDistrict> searchedPlaces = [];
  String searchPlaceController = '';
  String searchCityController = '';

  List<City> cities = [];
  List<City> searchedCities = [];

  Future initialLoadItems() async =>
      cities = await databaseService.categories.getAllCities();

  Future selectCity(final String city) async {
    _places = await databaseService.categories.getCityDistricts(city);
  }

  void searchCities(String query) {
    List<City> resList = [];
    for (var item in cities) {
      if (item.name.toLowerCase().contains(query.toLowerCase().trimLeft())) {
        resList.add(item);
      }
    }
    searchedCities = resList.take(10).toList();
  }

  void searchPlacesByName(String query) {
    List<CityDistrict> resList = [];
    for (var item in _places) {
      if (item.name.toLowerCase().contains(query.toLowerCase().trimLeft())) {
        resList.add(item);
      }
    }
    searchedPlaces = resList.take(10).toList();
  }

  CityDistrict? searchPlaceIdByName(value) {
    for (var item in _places) {
      if (item.name == value) {
        return item;
      }
    }
    return null;
  }

  String? searchCityIdByName(value) {
    for (var item in cities) {
      if (item.name == value) {
        return item.id;
      }
    }
    return null;
  }

  void clearSearchItems() {
    searchedPlaces.clear();
    searchedCities.clear();
  }

  void setCityController(String value) {
    searchCityController = value;
  }

  void setPlaceController(String value) {
    searchPlaceController = value;
  }
}
