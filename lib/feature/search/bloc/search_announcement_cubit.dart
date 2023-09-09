import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart/models/sorte_types.dart';

import '../../../managers/announcement_manager.dart';

part 'search_announcement_state.dart';

class SearchAnnouncementCubit extends Cubit<SearchAnnouncementState> {
  final AnnouncementManager _announcementManager;

  String? _lastText;

  String? _sortBy;
  double? _minPrice;
  double? _maxPrice;

  String get sortBy => _sortBy ?? SortTypes.dateDESC;

  double get minPrice => _minPrice ?? 0;

  double get maxPrice => _maxPrice ?? 200000;

  set sortType(String? searchType) => _sortBy = searchType;

  set minPrice(double price) => _minPrice = price;

  set maxPrice(double price) => _maxPrice = price;

  void clearFilters() {
    _sortBy = null;
    _minPrice = 0;
    _maxPrice = 200000;
    setFilters();
  }

  SearchAnnouncementCubit({required AnnouncementManager announcementManager})
      : _announcementManager = announcementManager,
        super(SearchAnnouncementInitial());

  void setFilters() async {
    emit(SearchAnnouncementsLoadingState());
    try {
      await _announcementManager.loadSearchAnnouncement(
          searchText: _lastText,
          isNew: true,
          sortBy: _sortBy,
          minPrice: _minPrice,
          maxPrice: _maxPrice);
      emit(SearchAnnouncementsSuccessState());
    } catch (e) {
      emit(SearchAnnouncementsFailState());
      rethrow;
    }
  }

  void searchAnnounces(String? searchText, bool isNew) async {
    emit(SearchAnnouncementsLoadingState());
    try {
      await _announcementManager.loadSearchAnnouncement(
          searchText: searchText,
          isNew: isNew,
          sortBy: _sortBy,
          minPrice: _minPrice,
          maxPrice: _maxPrice);
      _lastText = searchText;
      emit(SearchAnnouncementsSuccessState());
    } catch (e) {
      emit(SearchAnnouncementsFailState());
      rethrow;
    }
  }
}
