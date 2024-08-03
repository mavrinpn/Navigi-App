import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart/feature/create_announcement/data/models/marks_filter.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/models/key_word.dart';
import 'package:smart/models/sort_types.dart';
import 'package:smart/models/subcategory.dart';
import 'package:smart/utils/price_type.dart';

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
  PriceType _priceType = PriceType.dzd;

  String? _cityId;
  String? _distrinctId;
  String? get cityId => _cityId;
  String? get distrinctId => _distrinctId;
  String? _cityTitle;
  String? _distrinctTitle;
  String? get cityTitle => _cityTitle;
  String? get distrinctTitle => _distrinctTitle;

  String? subcategoryId;
  Subcategory? subcategory;

  String get sortBy => _sortBy ?? SortTypes.dateDESC;

  // ignore: unnecessary_getters_setters
  double? get minPrice => _minPrice; // ?? 0;

  // ignore: unnecessary_getters_setters
  double? get maxPrice => _maxPrice; // ?? 200000;

  // ignore: unnecessary_getters_setters
  PriceType get priceType => _priceType;

  set sortType(String? searchType) => _sortBy = searchType;

  set minPrice(double? price) => _minPrice = price;

  set maxPrice(double? price) => _maxPrice = price;

  set priceType(PriceType priceType) => _priceType = priceType;

  double radius = 0;

  final sortTypesParameter = SortTypes.sortTypesParameter();

  void clearFilters() {
    _sortBy = null;
    _minPrice = null;
    _maxPrice = null;
    _cityId = null;
    _distrinctId = null;
    _cityTitle = null;
    _distrinctTitle = null;
    marksFilter = null;
    // setFilters();
  }

  void clearCityFilters() {
    _cityId = null;
    _distrinctId = null;
    _cityTitle = null;
    _distrinctTitle = null;
  }

  SearchAnnouncementCubit({required AnnouncementManager announcementManager})
      : _announcementManager = announcementManager,
        super(SearchAnnouncementInitial());

  void setSearchMode(SearchModeEnum mode) => searchMode = mode;

  void setSubcategory(Subcategory? subcategory) {
    subcategoryId = subcategory?.id;
    subcategory = subcategory;
  }

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
      _distrinctId = areaId;
      _cityTitle = cityTitle;
      _distrinctTitle = areaTitle;

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
          subcategoryId: subcategoryId ?? '',
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
    } catch (err) {
      emit(SearchAnnouncementsFailState(error: err.toString()));
      // if (err.toString() != 'Bad state: No element') {
      //   rethrow;
      // }
    }
  }

  void setCity({
    String? cityId,
    String? areaId,
    String? cityTitle,
    String? areaTitle,
  }) {
    _cityId = cityId;
    _distrinctId = areaId;
    _cityTitle = cityTitle;
    _distrinctTitle = areaTitle;
  }

  void searchAnnounces({
    required String? searchText,
    required bool isNew,
    required bool showLoading,
    List<Parameter> parameters = const <Parameter>[],
    // String? cityId,
    // String? areaId,
    // String? cityTitle,
    // String? areaTitle,
  }) async {
    // _cityId = cityId;
    // _distrinctId = areaId;
    // _cityTitle = cityTitle;
    // _distrinctTitle = areaTitle;
    emit(SearchAnnouncementsLoadingState());
    // if (showLoading) {
    //   emit(SearchAnnouncementsLoadingState());
    // } else {
    //   emit(SearchAnnouncementsScrollLoadingState());
    // }

    try {
      if (searchMode == SearchModeEnum.simple) {
        await _announcementManager.loadSearchAnnouncement(
          searchText: searchText,
          isNew: isNew,
          sortBy: _sortBy,
          minPrice: _minPrice,
          maxPrice: _maxPrice,
          cityId: cityId,
          areaId: distrinctId,
        );
      } else {
        await _announcementManager.searchWithSubcategory(
          subcategoryId: subcategoryId!,
          parameters: parameters,
          searchText: searchText,
          isNew: isNew,
          sortBy: _sortBy,
          minPrice: _minPrice,
          maxPrice: _maxPrice,
          cityId: cityId,
          areaId: distrinctId,
        );
      }
      // await _announcementManager.loadSearchAnnouncement(
      //     searchText: searchText,
      //     isNew: isNew,
      //     sortBy: _sortBy,
      //     minPrice: _minPrice,
      //     maxPrice: _maxPrice);
      _lastText = searchText;
      emit(SearchAnnouncementsSuccessState());
    } catch (err) {
      emit(SearchAnnouncementsFailState(error: err.toString()));
      // if (err.toString() != 'Bad state: No element') {
      //   rethrow;
      // }
    }
  }

  void searchAnnouncesByKeyword({
    required KeyWord keyword,
    required bool isNew,
  }) async {
    emit(SearchAnnouncementsLoadingState());
    try {
      if (searchMode == SearchModeEnum.simple) {
        await _announcementManager.loadSearchAnnouncement(
          keyword: keyword,
          isNew: true,
          sortBy: _sortBy,
          mark: keyword.mark,
          model: keyword.model,
        );
      } else {
        await _announcementManager.searchWithSubcategory(
          subcategoryId: subcategoryId!,
          parameters: const <Parameter>[],
          keyword: keyword,
          isNew: true,
          sortBy: _sortBy,
          mark: keyword.mark,
          model: keyword.model,
          type: keyword.type,
        );
      }
      _lastText = keyword.nameFr;
      emit(SearchAnnouncementsSuccessState());
    } catch (err) {
      emit(SearchAnnouncementsFailState(error: err.toString()));
      // if (err.toString() != 'Bad state: No element') {
      //   rethrow;
      // }
    }
  }
}
