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
  List<Announcement> announcements = [];
  List<Announcement> searchAnnouncements = [];
  Announcement? lastAnnouncement;

  BehaviorSubject<LoadingStateEnum> announcementsLoadingState = BehaviorSubject.seeded(LoadingStateEnum.loading);

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
          announcements.clear();
          _lastId = '';
          _excludeRecomendationsCity = false;
          _excludeRecomendationsArea = false;
          _cityIncludeRecomendationsTotal = 0;
        }

        if (!_excludeRecomendationsCity && !_excludeRecomendationsArea) {
          await _recomendationsWithCityInclude(uid, cityId: cityId, areaId: areaId);
        }

        if (!_excludeCity && _excludeRecomendationsArea) {
          await _recomendationsWithAreaExclude(uid, cityId: cityId, areaId: areaId);
        }

        if (_excludeRecomendationsCity && _excludeRecomendationsArea) {
          await _recomendationsWithCityExclude(uid, cityId: cityId, areaId: areaId);
        }

        // final newAnnouncements = await dbService.announcements.getAnnouncements(
        //   lastId: _lastId,
        //   excudeUserId: uid,
        //   cityId: cityId,
        //   areaId: areaId,
        // );

        // announcements.addAll(newAnnouncements);
        // _lastId = announcements.last.anouncesTableId;
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
    ({List<Announcement> list, int total}) results;
    results = await dbService.announcements.getAnnouncements(
      lastId: _lastId,
      excudeUserId: uid,
      cityId: cityId,
      areaId: areaId,
    );
    // print('_recomendationsWithCityInclude ${results.list.length} from ${results.total}');

    announcements.addAll(results.list);
    _lastId = announcements.last.anouncesTableId;

    _cityIncludeRecomendationsTotal = results.total;

    debugPrint('results.length ${results.list.length}');
    debugPrint('announcements.length ${announcements.length}');
    debugPrint('total ${results.total}');

    if (announcements.length >= results.total) {
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
    // print('_recomendationsWithCityExclude ${results.list.length}');

    announcements.addAll(results.list);
    _lastId = announcements.last.anouncesTableId;

    debugPrint('results.length ${results.list.length}');
    debugPrint('announcements.length ${announcements.length}');
    debugPrint('total ${results.total}');

    if (announcements.length >= results.total + _cityIncludeRecomendationsTotal) {
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
    debugPrint('announcements.length ${announcements.length}');
    debugPrint('total ${results.total}');

    announcements.addAll(results.list);
    _lastId = announcements.last.anouncesTableId;
  }

  Future<Announcement?> getAnnouncementById(String id) async {
    final localAnnouncement = _getAnnouncementFromLocal(id);
    if (localAnnouncement != null) return localAnnouncement;

    final announcement = await dbService.announcements.getAnnouncementById(id);
    return announcement;
  }

  Future<Announcement?> refreshAnnouncement(String id) async {
    for (var a in announcements) {
      if (a.anouncesTableId == id) {
        a = await dbService.announcements.getAnnouncementById(id);
        lastAnnouncement = a;
        return a;
      }
    }
    for (var a in searchAnnouncements) {
      if (a.anouncesTableId == id) {
        a = await dbService.announcements.getAnnouncementById(id);
        lastAnnouncement = a;
        return a;
      }
    }

    return await dbService.announcements.getAnnouncementById(id);
  }

  Announcement? _getAnnouncementFromLocal(String id) {
    for (var a in announcements) {
      if (a.anouncesTableId == id) {
        lastAnnouncement = a;
        return a;
      }
    }
    for (var a in searchAnnouncements) {
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
      searchAnnouncements.clear();
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
    ({List<Announcement> list, int total}) results;
    results = await dbService.announcements.searchAnnouncementsInSubcategory(
      filterData: filter,
    );

    searchAnnouncements.addAll(results.list);
    _searchLastId = searchAnnouncements.lastOrNull?.subTableId ?? '';

    debugPrint('results.length ${results.list.length}');
    debugPrint('searchAnnouncements.length ${searchAnnouncements.length}');
    debugPrint('total ${results.total}');

    _cityIncludeTotal = results.total;

    if (searchAnnouncements.length >= results.total) {
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

    searchAnnouncements.addAll(results.list);
    _searchLastId = searchAnnouncements.last.subTableId;

    debugPrint('results.length ${results.list.length}');
    debugPrint('searchAnnouncements.length ${searchAnnouncements.length}');
    debugPrint('total ${results.total}');

    if (searchAnnouncements.length >= results.total + _cityIncludeTotal) {
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

    searchAnnouncements.addAll(results.list);
    _searchLastId = searchAnnouncements.last.subTableId;

    debugPrint('results.length ${results.list.length}');
    debugPrint('searchAnnouncements.length ${searchAnnouncements.length}');
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
        searchAnnouncements.clear();
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

      searchAnnouncements.addAll(await dbService.announcements.searchLimitAnnouncements(filter));

      _searchLastId = searchAnnouncements.last.anouncesTableId;
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
