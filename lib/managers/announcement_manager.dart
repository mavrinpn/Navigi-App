import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smart/enum/enum.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/models/key_word.dart';
import 'package:smart/services/filters/filter_dto.dart';

import '../../models/announcement.dart';
import '../services/database/database_service.dart';

class AnnouncementManager {
  final DatabaseService dbService;
  final Account account;

  AnnouncementManager({required Client client})
      : dbService = DatabaseService(client: client),
        account = Account(client);

  String? _lastId;
  String? _searchLastId;

  bool _excludeCity = false;
  bool _excludeArea = false;
  int _cityIncludeTotal = 0;

  bool _excludeRecomendationsCity = false;
  bool _excludeRecomendationsArea = false;
  int _cityIncludeRecomendationsTotal = 0;

  bool _canGetMoreAnnouncement = true;

  List<String> viewsAnnouncements = [];
  List<String> contactsAnnouncements = [];

  List<Announcement> recommendationAnnouncementsWithExactLocation = [];
  // List<Announcement> recommendationAnnouncementsWithCityLocation = [];
  List<Announcement> recommendationAnnouncementsWithOtherLocation = [];

  List<Announcement> searchAnnouncementsWithExactLocation = [];
  // List<Announcement> searchAnnouncementsWithCityLocation = [];
  List<Announcement> searchAnnouncementsWithOtherLocation = [];

  Announcement? lastAnnouncement;

  BehaviorSubject<LoadingStateEnum> announcementsLoadingState = BehaviorSubject.seeded(LoadingStateEnum.loading);

  void clear() {
    recommendationAnnouncementsWithExactLocation.clear();
    // recommendationAnnouncementsWithCityLocation.clear();
    recommendationAnnouncementsWithOtherLocation.clear();
    _lastId = '';
    _excludeRecomendationsCity = false;
    _excludeRecomendationsArea = false;
    _cityIncludeRecomendationsTotal = 0;
  }

  Future<void> addLimitAnnouncements(
    bool isNew, {
    String? cityId,
    String? areaId,
  }) async {
    announcementsLoadingState.add(LoadingStateEnum.loading);

    if (_canGetMoreAnnouncement) {
      String? uid;

      try {
        final user = await account.get();
        uid = user.$id;
        // ignore: empty_catches
      } catch (err) {}

      try {
        if (isNew) {
          clear();
        }

        if (!_excludeRecomendationsCity && !_excludeRecomendationsArea) {
          await _recomendationsWithCityInclude(uid, cityId: cityId, areaId: areaId);
        }

        if (!_excludeRecomendationsCity && _excludeRecomendationsArea) {
          await _recomendationsWithAreaExclude(uid, cityId: cityId, areaId: areaId);
        }

        if (_excludeRecomendationsCity && _excludeRecomendationsArea) {
          await _recomendationsWithCityExclude(uid, cityId: cityId, areaId: areaId);
        }
      } catch (e) {
        if (e.toString() != 'Bad state: No element') {
          rethrow;
        } else {
          _canGetMoreAnnouncement = false;
        }
      }
    }
    announcementsLoadingState.add(LoadingStateEnum.success);
  }

  _recomendationsWithCityInclude(
    String? uid, {
    String? cityId,
    String? areaId,
  }) async {
    debugPrint('_recomendationsWithCityInclude');

    if (areaId == null) {
      _lastId = null;
      _excludeRecomendationsArea = true;
      return;
    }

    ({List<Announcement> list, int total}) results;
    results = await dbService.announcements.getAnnouncements(
      lastId: _lastId,
      excudeUserId: uid,
      cityId: cityId,
      areaId: areaId,
    );

    recommendationAnnouncementsWithExactLocation.addAll(results.list);
    _lastId = recommendationAnnouncementsWithExactLocation.lastOrNull?.anouncesTableId;

    _cityIncludeRecomendationsTotal = results.total;

    debugPrint('results.length ${results.list.length}');
    debugPrint('announcements.length ${recommendationAnnouncementsWithExactLocation.length}');
    debugPrint('total ${results.total}');

    if (recommendationAnnouncementsWithExactLocation.length >= results.total) {
      _lastId = null;
      _excludeRecomendationsArea = true;
    }
  }

  _recomendationsWithAreaExclude(
    String? uid, {
    String? areaId,
    String? cityId,
  }) async {
    debugPrint('_recomendationsWithAreaExclude');

    ({List<Announcement> list, int total}) results;
    results = await dbService.announcements.getAnnouncements(
      lastId: _lastId,
      excudeUserId: uid,
      cityId: cityId,
      excludeAreaId: areaId,
    );

    recommendationAnnouncementsWithExactLocation.addAll(results.list);
    _lastId = recommendationAnnouncementsWithExactLocation.lastOrNull?.anouncesTableId;

    debugPrint('results.length ${results.list.length}');
    debugPrint('announcements.length ${recommendationAnnouncementsWithExactLocation.length}');
    debugPrint('total ${results.total}');

    if (recommendationAnnouncementsWithExactLocation.length >= results.total + _cityIncludeRecomendationsTotal) {
      _lastId = null;
      _excludeRecomendationsArea = true;
      _excludeRecomendationsCity = true;
    }
  }

  _recomendationsWithCityExclude(
    String? uid, {
    String? cityId,
    String? areaId,
  }) async {
    debugPrint('_recomendationsWithCityExclude');

    ({List<Announcement> list, int total}) results;
    results = await dbService.announcements.getAnnouncements(
      lastId: _lastId,
      excudeUserId: uid,
      excludeCityId: cityId,
      excludeAreaId: areaId,
    );

    debugPrint('results.length ${results.list.length}');
    debugPrint('announcements.length ${recommendationAnnouncementsWithOtherLocation.length}');
    debugPrint('total ${results.total}');

    recommendationAnnouncementsWithOtherLocation.addAll(results.list);
    _lastId = recommendationAnnouncementsWithOtherLocation.lastOrNull?.anouncesTableId;
  }

  Future<Announcement?> getAnnouncementById(String id) async {
    final localAnnouncement = _getAnnouncementFromLocal(id);
    if (localAnnouncement != null) return localAnnouncement;

    final announcement = await dbService.announcements.getAnnouncementById(id);
    return announcement;
  }

  Future<Announcement?> refreshAnnouncement(String id) async {
    for (var a in recommendationAnnouncementsWithExactLocation) {
      if (a.anouncesTableId == id) {
        a = await dbService.announcements.getAnnouncementById(id);
        lastAnnouncement = a;
        return a;
      }
    }
    // for (var a in recommendationAnnouncementsWithCityLocation) {
    //   if (a.anouncesTableId == id) {
    //     a = await dbService.announcements.getAnnouncementById(id);
    //     lastAnnouncement = a;
    //     return a;
    //   }
    // }
    for (var a in recommendationAnnouncementsWithOtherLocation) {
      if (a.anouncesTableId == id) {
        a = await dbService.announcements.getAnnouncementById(id);
        lastAnnouncement = a;
        return a;
      }
    }
    for (var a in searchAnnouncementsWithExactLocation) {
      if (a.anouncesTableId == id) {
        a = await dbService.announcements.getAnnouncementById(id);
        lastAnnouncement = a;
        return a;
      }
    }
    for (var a in searchAnnouncementsWithOtherLocation) {
      if (a.anouncesTableId == id) {
        a = await dbService.announcements.getAnnouncementById(id);
        lastAnnouncement = a;
        return a;
      }
    }

    return await dbService.announcements.getAnnouncementById(id);
  }

  Announcement? _getAnnouncementFromLocal(String id) {
    for (var a in recommendationAnnouncementsWithExactLocation) {
      if (a.anouncesTableId == id) {
        lastAnnouncement = a;
        return a;
      }
    }
    // for (var a in recommendationAnnouncementsWithCityLocation) {
    //   if (a.anouncesTableId == id) {
    //     lastAnnouncement = a;
    //     return a;
    //   }
    // }
    for (var a in recommendationAnnouncementsWithOtherLocation) {
      if (a.anouncesTableId == id) {
        lastAnnouncement = a;
        return a;
      }
    }
    for (var a in searchAnnouncementsWithExactLocation) {
      if (a.anouncesTableId == id) {
        lastAnnouncement = a;
        return a;
      }
    }
    for (var a in searchAnnouncementsWithOtherLocation) {
      if (a.anouncesTableId == id) {
        lastAnnouncement = a;
        return a;
      }
    }
    return null;
  }

  void incTotalViews(String id) async {
    if (!viewsAnnouncements.contains(id)) {
      dbService.announcements.incTotalViewsById(id);
      viewsAnnouncements.add(id);
    }
  }

  void incContactsViews(String id) async {
    if (!contactsAnnouncements.contains(id)) {
      dbService.announcements.incContactsViewsById(id);
      contactsAnnouncements.add(id);
    }
  }

  Future<void> searchWithSubcategory({
    String? searchText,
    KeyWord? keyword,
    required bool isNew,
    required String subcategoryId,
    required List<Parameter> parameters,
    String? mark,
    String? model,
    String? type,
    String? sortBy,
    double? minPrice,
    double? maxPrice,
    double? radius,
    String? cityId,
    String? areaId,
  }) async {
    if (isNew) {
      searchAnnouncementsWithExactLocation.clear();
      searchAnnouncementsWithOtherLocation.clear();
      _searchLastId = '';
      _excludeCity = false;
      _excludeArea = false;
      _cityIncludeTotal = 0;
    }
    final filter = SubcategoryFilterDTO(
      lastId: _searchLastId,
      text: searchText,
      keyword: keyword,
      sortBy: sortBy,
      minPrice: minPrice,
      maxPrice: maxPrice,
      radius: radius,
      subcategory: subcategoryId,
      parameters: parameters,
      mark: mark,
      model: model,
      type: type,
      cityId: cityId,
      areaId: areaId,
    );

    if (!_excludeCity && !_excludeArea) {
      await _searchWithCityInclude(filter);
    }

    if (!_excludeCity && _excludeArea) {
      await _searchWithAreaExclude(filter);
    }

    if (_excludeCity && _excludeArea) {
      await _searchWithCityExclude(filter);
    }
  }

  _searchWithCityInclude(SubcategoryFilterDTO filter) async {
    debugPrint('_searchWithCityInclude');

    if (filter.areaId == null) {
      _searchLastId = null;
      _excludeArea = true;
      return;
    }

    ({List<Announcement> list, int total}) results;
    results = await dbService.announcements.searchAnnouncementsInSubcategory(
      filterData: filter,
    );

    searchAnnouncementsWithExactLocation.addAll(results.list);
    _searchLastId = searchAnnouncementsWithExactLocation.lastOrNull?.subTableId ?? '';

    debugPrint('results.length ${results.list.length}');
    debugPrint('searchAnnouncements.length ${searchAnnouncementsWithExactLocation.length}');
    debugPrint('total ${results.total}');

    _cityIncludeTotal = results.total;

    if (searchAnnouncementsWithExactLocation.length >= results.total) {
      _searchLastId = null;
      _excludeArea = true;
    }
  }

  _searchWithAreaExclude(SubcategoryFilterDTO filter) async {
    debugPrint('_searchWithAreaExclude');
    ({List<Announcement> list, int total}) results;
    results = await dbService.announcements.searchAnnouncementsInSubcategory(
      filterData: filter,
      excludeAreaId: filter.areaId,
    );

    searchAnnouncementsWithExactLocation.addAll(results.list);
    _searchLastId = searchAnnouncementsWithExactLocation.lastOrNull?.subTableId;

    debugPrint('results.length ${results.list.length}');
    debugPrint('searchAnnouncements.length ${searchAnnouncementsWithExactLocation.length}');
    debugPrint('total ${results.total}');

    if (searchAnnouncementsWithExactLocation.length >= results.total + _cityIncludeTotal) {
      _searchLastId = null;
      _excludeArea = true;
      _excludeCity = true;
    }
  }

  _searchWithCityExclude(SubcategoryFilterDTO filter) async {
    debugPrint('_searchWithCityExclude');
    ({List<Announcement> list, int total}) results;
    results = await dbService.announcements.searchAnnouncementsInSubcategory(
      filterData: filter,
      excludeCityId: filter.cityId,
      excludeAreaId: filter.areaId,
    );

    searchAnnouncementsWithOtherLocation.addAll(results.list);
    _searchLastId = searchAnnouncementsWithOtherLocation.lastOrNull?.subTableId;

    debugPrint('results.length ${results.list.length}');
    debugPrint('searchAnnouncements.length ${searchAnnouncementsWithOtherLocation.length}');
    debugPrint('total ${results.total}');
  }

  Future<void> loadSearchAnnouncement({
    String? searchText,
    KeyWord? keyword,
    required bool isNew,
    String? sortBy,
    double? minPrice,
    double? maxPrice,
    double? radius,
    String? cityId,
    String? areaId,
    String? mark,
    String? model,
    String? type,
  }) async {
    try {
      if (isNew) {
        searchAnnouncementsWithExactLocation.clear();
        searchAnnouncementsWithOtherLocation.clear();
        _searchLastId = '';
      }

      final filter = DefaultFilterDto(
        lastId: _searchLastId,
        text: searchText,
        keyword: keyword,
        sortBy: sortBy,
        minPrice: minPrice,
        maxPrice: maxPrice,
        radius: radius,
        cityId: cityId,
        areaId: areaId,
        mark: mark,
        model: model,
        type: type,
      );

      searchAnnouncementsWithExactLocation.addAll(await dbService.announcements.searchLimitAnnouncements(filter));

      _searchLastId = searchAnnouncementsWithExactLocation.last.anouncesTableId;
    } catch (e) {
      if (e.toString() != 'Bad state: No element') {
        rethrow;
      }
    }
  }

  Future<void> changeActivity(String announcementId) async {
    await dbService.announcements.changeAnnouncementActivity(announcementId);
  }
}
