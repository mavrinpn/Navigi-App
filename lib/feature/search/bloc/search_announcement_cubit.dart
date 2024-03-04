import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart/feature/create_announcement/data/models/marks_filter.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/models/sort_types.dart';

import '../../../managers/announcement_manager.dart';

part 'search_announcement_state.dart';

enum SearchModeEnum { simple, subcategory }

class SearchAnnouncementCubit extends Cubit<SearchAnnouncementState> {
  final AnnouncementManager _announcementManager;

  SearchModeEnum searchMode = SearchModeEnum.simple;

  MarksFilter? marksFilter;

  String? _lastText;

  String? _sortBy;
  double? _minPrice;
  double? _maxPrice;

  String? _cityId;
  String? _areaId;
  String? get cityId => _cityId;
  String? get areaId => _areaId;
  String? _cityTitle;
  String? _areaTitle;
  String? get cityTitle => _cityTitle;
  String? get areaTitle => _areaTitle;

  String? _subcategoryId;

  String get sortBy => _sortBy ?? SortTypes.dateDESC;

  double get minPrice => _minPrice ?? 0;

  double get maxPrice => _maxPrice ?? 200000;

  set sortType(String? searchType) => _sortBy = searchType;

  set minPrice(double price) => _minPrice = price;

  set maxPrice(double price) => _maxPrice = price;

  double radius = 0;

  final sortTypesParameter = SortTypes.sortTypesParameter();

  void clearFilters() {
    _sortBy = null;
    _minPrice = 0;
    _maxPrice = 200000;
    _cityId = null;
    _areaId = null;
    _cityTitle = null;
    _areaTitle = null;
    marksFilter = null;
    setFilters();
  }

  SearchAnnouncementCubit({required AnnouncementManager announcementManager})
      : _announcementManager = announcementManager,
        super(SearchAnnouncementInitial());

  void setSearchMode(SearchModeEnum mode) => searchMode = mode;

  void setSubcategory(String id) => _subcategoryId = id;

  void setMarksFilter(MarksFilter? newMarksFilter) {
    marksFilter = newMarksFilter;
  }

  void setFilters({
    List<Parameter>? parameters,
    String? cityId,
    String? areaId,
    String? cityTitle,
    String? areaTitle,
  }) async {
    emit(SearchAnnouncementsLoadingState());
    try {
      _cityId = cityId;
      _areaId = areaId;
      _cityTitle = cityTitle;
      _areaTitle = areaTitle;

      if (searchMode == SearchModeEnum.simple) {
        await _announcementManager.loadSearchAnnouncement(
          searchText: _lastText,
          isNew: true,
          sortBy: _sortBy,
          minPrice: _minPrice,
          maxPrice: _maxPrice,
          cityId: cityId,
          areaId: areaId,
        );
      } else {
        await _announcementManager.searchWithSubcategory(
          subcategoryId: _subcategoryId ?? '',
          parameters: parameters ?? [],
          searchText: _lastText,
          isNew: true,
          sortBy: _sortBy,
          minPrice: _minPrice,
          maxPrice: _maxPrice,
          mark: marksFilter?.markId,
          model: marksFilter?.modelId,
          cityId: cityId,
          areaId: areaId,
        );
      }

      emit(SearchAnnouncementsSuccessState());
    } catch (e) {
      emit(SearchAnnouncementsFailState());
      rethrow;
    }
  }

  void searchAnnounces({
    required String? searchText,
    required bool isNew,
    List<Parameter> parameters = const <Parameter>[],
  }) async {
    emit(SearchAnnouncementsLoadingState());
    try {
      if (searchMode == SearchModeEnum.simple) {
        await _announcementManager.loadSearchAnnouncement(
            searchText: searchText,
            isNew: true,
            sortBy: _sortBy,
            minPrice: _minPrice,
            maxPrice: _maxPrice);
      } else {
        await _announcementManager.searchWithSubcategory(
            subcategoryId: _subcategoryId!,
            parameters: parameters,
            searchText: searchText,
            isNew: true,
            sortBy: _sortBy,
            minPrice: _minPrice,
            maxPrice: _maxPrice);
      }
      // await _announcementManager.loadSearchAnnouncement(
      //     searchText: searchText,
      //     isNew: isNew,
      //     sortBy: _sortBy,
      //     minPrice: _minPrice,
      //     maxPrice: _maxPrice);
      _lastText = searchText;
      emit(SearchAnnouncementsSuccessState());
    } catch (e) {
      emit(SearchAnnouncementsFailState());
      rethrow;
    }
  }
}
