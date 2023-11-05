import 'package:appwrite/appwrite.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/enum/enum.dart';

import '../../models/announcement.dart';
import '../services/database_service.dart';

class AnnouncementManager {
  final DatabaseService dbManager;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  AnnouncementManager({required Client client})
      : dbManager = DatabaseService(client: client);

  String? _lastId;
  String? _searchLastId;
  bool _canGetMoreAnnouncement = true;
  bool _canGetMoreSearchAnnouncement = true;

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

        announcements.addAll(await dbManager.getAnnouncements(_lastId));
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

    final announcement = await dbManager.getAnnouncementById(id);
    return announcement;
  }

  void incTotalViews(String id) async {
    if (!viewsAnnouncements.contains(id)) {
      dbManager.incTotalViewsById(id);
      viewsAnnouncements.add(id);
    }
  }

  Future<void> loadSearchAnnouncement(
      {String? searchText,
      required bool isNew,
      String? sortBy,
      double? minPrice,
      double? maxPrice}) async {
    try {
      if (isNew) {
        searchAnnouncements = <Announcement>[];
        _searchLastId = '';
      }

      searchAnnouncements.addAll(await dbManager.searchLimitAnnouncements(
          _searchLastId, searchText, sortBy,
          minPrice: minPrice, maxPrice: maxPrice));

      _searchLastId = searchAnnouncements.last.id;
    } catch (e) {
      if (e.toString() != 'Bad state: No element') {
        rethrow;
      } else {
        _canGetMoreSearchAnnouncement = false;
      }
    }
  }

  Future<void> changeActivity(String announcementId) async {
    await dbManager.changeAnnouncementActivity(announcementId);
  }
}
