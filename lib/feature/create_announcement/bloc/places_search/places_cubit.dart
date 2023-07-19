import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart/models/announcement.dart';

import '../../../../managers/creating_announcement_manager.dart';
import '../../../../managers/places_manager.dart';

part 'places_state.dart';

class PlacesCubit extends Cubit<PlacesState> {
  final CreatingAnnouncementManager creatingManager;
  final PlacesManager placesManager;

  PlacesCubit({required this.creatingManager,required this.placesManager}) : super(PlacesInitial());

  void initialLoad() {
    emit(PlacesLoadingState());
    try {
      placesManager.searchController = '';
      placesManager.initialLoadItems();
      placesManager.clearSearchItems();
      emit(PlacesEmptyState());
    } catch (e) {
      emit(PlacesFailState());
    }
  }

  List<PlaceData> getPlaces() => placesManager.searchedPlaces;

  void setPlaceName(String name) => placesManager.setSearchController(name);

  void searchPlaces(String query) {
    emit(PlacesLoadingState());
    placesManager.searchController = query;

    if (query.isEmpty) {
      placesManager.clearSearchItems();
      emit(PlacesEmptyState());
      return;
    }

    placesManager.searchPlacesByName(query);
    emit(PlacesSuccessState());
  }

  String getSearchText() => placesManager.searchController;
}
