import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/models/city.dart';

import '../../../../managers/creating_announcement_manager.dart';
import '../../../../managers/places_manager.dart';

part 'places_state.dart';

class PlacesCubit extends Cubit<PlacesState> {
  final CreatingAnnouncementManager creatingManager;
  final PlacesManager placesManager;

  PlacesCubit({required this.creatingManager, required this.placesManager})
      : super(PlacesInitial());

  void initialLoad() {
    emit(PlacesLoadingState());
    try {
      placesManager.searchPlaceController = '';
      placesManager.searchCityController = '';
      placesManager.initialLoadItems();
      placesManager.clearSearchItems();
      emit(PlacesEmptyState());
    } catch (e) {
      emit(PlacesFailState());
    }
  }

  List<CityDistrict> getPlaces() => placesManager.searchedPlaces;

  List<City> getCities() => placesManager.searchedCities;

  void setPlaceName(String name) => placesManager.setPlaceController(name);

  Future setCity(City city) async {
    emit(PlacesLoadingState());
    placesManager.setCityController(city.name);
    await placesManager.selectCity(city.id);
    emit(PlacesSuccessState());
  }

  void searchPlaces(String query) {
    emit(PlacesLoadingState());
    placesManager.searchPlaceController = query;

    if (query.isEmpty) {
      emit(PlacesEmptyState());
      return;
    }

    placesManager.searchPlacesByName(query);
    emit(PlacesSuccessState());
  }

  void searchCities(String query) {
    emit(PlacesLoadingState());
    placesManager.searchCityController = query;

    if (query.isEmpty) {
      placesManager.clearSearchItems();
      emit(PlacesEmptyState());
      return;
    }

    placesManager.searchCities(query);
    emit(PlacesSuccessState());
  }

  String getSearchText() => placesManager.searchPlaceController;
}
