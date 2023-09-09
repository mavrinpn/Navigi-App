import 'package:appwrite/appwrite.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/announcement.dart';
import '../services/database_service.dart';

class AnnouncementManager {
  final DatabaseManger dbManager;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  AnnouncementManager({required Client client})
      : dbManager = DatabaseManger(client: client);

  String? _lastId;
  String? _searchLastId;
  bool _canGetMoreAnnouncement = true;
  bool _canGetMoreSearchAnnouncement = true;

  List<String> viewsAnnouncements = [];
  List<Announcement> announcements = [];
  List<Announcement> searchAnnouncements = [];
  Announcement? lastAnnouncement;

  Future<void> addLimitAnnouncements(bool isNew) async {
    if (_canGetMoreAnnouncement) {
      try {
        if (isNew) {
          announcements = [];
          _lastId = '';
        }

        announcements.addAll(await dbManager.loadLimitAnnouncements(_lastId));
        _lastId = announcements.last.announcementId;
      } catch (e) {
        if (e.toString() != 'Bad state: No element') {
          rethrow;
        } else {
          _canGetMoreAnnouncement = false;
        }
      }
    }
  }

  Future<Announcement?> getAnnouncementById(String id) async {
    for (var a in announcements) {
      if (a.announcementId == id) {
        lastAnnouncement = a;
        return a;
      }
    }
    for (var a in searchAnnouncements) {
      if (a.announcementId == id) {
        lastAnnouncement = a;
        return a;
      }
    }
    return null;
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
          _searchLastId, searchText, sortBy));

      _searchLastId = searchAnnouncements.last.announcementId;
    } catch (e) {
      if (e.toString() != 'Bad state: No element') {
        rethrow;
      } else {
        _canGetMoreSearchAnnouncement = false;
      }
    }
  }
}
