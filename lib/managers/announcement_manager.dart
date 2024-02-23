import 'package:appwrite/appwrite.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/enum/enum.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/services/filters/filter_dto.dart';

import '../../models/announcement.dart';
import '../services/database/database_service.dart';

class AnnouncementManager {
  final DatabaseService dbService;

  AnnouncementManager({required Client client})
      : dbService = DatabaseService(client: client);

  String? _lastId;
  String? _searchLastId;
  bool _canGetMoreAnnouncement = true;

  List<String> viewsAnnouncements = [];
  List<Announcement> announcements = [];
  List<Announcement> searchAnnouncements = [];
  Announcement? lastAnnouncement;

  BehaviorSubject<LoadingStateEnum> announcementsLoadingState =
      BehaviorSubject.seeded(LoadingStateEnum.loading);

  Future<void> addLimitAnnouncements(bool isNew) async {
    announcementsLoadingState.add(LoadingStateEnum.loading);
    if (_canGetMoreAnnouncement) {
      try {
        if (isNew) {
          announcements = [];
          _lastId = '';
        }

        announcements
            .addAll(await dbService.announcements.getAnnouncements(_lastId));
        _lastId = announcements.last.id;
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

  Future<Announcement?> getAnnouncementById(String id) async {
    final localAnnouncement = _getAnnouncementFromLocal(id);
    if (localAnnouncement != null) return localAnnouncement;

    final announcement = await dbService.announcements.getAnnouncementById(id);
    return announcement;
  }

  Future<Announcement?> refreshAnnouncement(String id) async {
    for (var a in announcements) {
      if (a.id == id) {
        a = await dbService.announcements.getAnnouncementById(id);
        lastAnnouncement = a;
        return a;
      }
    }
    for (var a in searchAnnouncements) {
      if (a.id == id) {
        a = await dbService.announcements.getAnnouncementById(id);
        lastAnnouncement = a;
        return a;
      }
    }

    return await dbService.announcements.getAnnouncementById(id);
  }

  Announcement? _getAnnouncementFromLocal(String id) {
    for (var a in announcements) {
      if (a.id == id) {
        lastAnnouncement = a;
        return a;
      }
    }
    for (var a in searchAnnouncements) {
      if (a.id == id) {
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

  Future<void> searchWithSubcategory(
      {String? searchText,
      required bool isNew,
      required String subcategoryId,
      required List<Parameter> parameters,
      String? mark,
      String? model,
      String? sortBy,
      double? minPrice,
      double? maxPrice,
      double? radius}) async {
    try {
      if (isNew) {
        searchAnnouncements.clear();
        _searchLastId = '';
      }

      final filter = SubcategoryFilterDTO(
          lastId: _searchLastId,
          text: searchText,
          sortBy: sortBy,
          minPrice: minPrice,
          maxPrice: maxPrice,
          radius: radius,
          subcategory: subcategoryId,
          parameters: parameters);

      searchAnnouncements.addAll(await dbService.announcements
          .searchAnnouncementsInSubcategory(filter));

      _searchLastId = searchAnnouncements.last.id;
    } catch (e) {
      if (e.toString() != 'Bad state: No element') {
        rethrow;
      }
    }
  }

  Future<void> loadSearchAnnouncement(
      {String? searchText,
      required bool isNew,
      String? sortBy,
      double? minPrice,
      double? maxPrice,
      double? radius}) async {
    try {
      if (isNew) {
        searchAnnouncements.clear();
        _searchLastId = '';
      }

      final filter = DefaultFilterDto(
          lastId: _searchLastId,
          text: searchText,
          sortBy: sortBy,
          minPrice: minPrice,
          maxPrice: maxPrice,
          radius: radius);

      searchAnnouncements.addAll(
          await dbService.announcements.searchLimitAnnouncements(filter));

      _searchLastId = searchAnnouncements.last.id;
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
