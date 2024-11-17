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

  Future initialLoadItems() async => cities = await databaseService.categories.getAllCities();

  Future selectCity(final String city) async {
    if (city.isNotEmpty) {
      _places = await databaseService.categories.getCityDistricts(city);
    }
  }

  void searchCities(String query) {
    List<City> resList = [];
    if (query.isEmpty) {
      searchedCities = resList;
      return;
    }
    for (var item in cities) {
      final name = item.name.toLowerCase();
      final lowerTextRow = query.toLowerCase().trimLeft();
      if (name.contains(lowerTextRow)) resList.add(item);

      if (lowerTextRow.contains('e')) {
        if (name.contains(lowerTextRow.replaceAll('e', 'é'))) resList.add(item);
        if (name.contains(lowerTextRow.replaceAll('e', 'è'))) resList.add(item);
      }
      if (lowerTextRow.contains('é')) {
        if (name.contains(lowerTextRow.replaceAll('é', 'e'))) resList.add(item);
        if (name.contains(lowerTextRow.replaceAll('é', 'è'))) resList.add(item);
      }
      if (lowerTextRow.contains('è')) {
        if (name.contains(lowerTextRow.replaceAll('è', 'e'))) resList.add(item);
        if (name.contains(lowerTextRow.replaceAll('è', 'é'))) resList.add(item);
      }

      const arThe = 'ال';
      RegExp arabicRegExp = RegExp(r'[\u0600-\u06FF]');
      if (!lowerTextRow.contains(arThe) && arabicRegExp.hasMatch(lowerTextRow)) {
        if (name.contains('$lowerTextRow$arThe')) resList.add(item);
      }
    }
    searchedCities = resList.take(10).toList();
  }

  void searchPlacesByName(String query) {
    List<CityDistrict> resList = [];
    for (var item in _places) {
      final name = item.name.toLowerCase();
      final lowerTextRow = query.toLowerCase().trimLeft();
      if (name.contains(lowerTextRow)) resList.add(item);

      if (lowerTextRow.contains('e')) {
        if (name.contains(lowerTextRow.replaceAll('e', 'é'))) resList.add(item);
        if (name.contains(lowerTextRow.replaceAll('e', 'è'))) resList.add(item);
      }
      if (lowerTextRow.contains('é')) {
        if (name.contains(lowerTextRow.replaceAll('é', 'e'))) resList.add(item);
        if (name.contains(lowerTextRow.replaceAll('é', 'è'))) resList.add(item);
      }
      if (lowerTextRow.contains('è')) {
        if (name.contains(lowerTextRow.replaceAll('è', 'e'))) resList.add(item);
        if (name.contains(lowerTextRow.replaceAll('è', 'é'))) resList.add(item);
      }

      const arThe = 'ال';
      RegExp arabicRegExp = RegExp(r'[\u0600-\u06FF]');
      if (!lowerTextRow.contains(arThe) && arabicRegExp.hasMatch(lowerTextRow)) {
        if (name.contains('$lowerTextRow$arThe')) resList.add(item);
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
