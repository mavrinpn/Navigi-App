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

  Future<void> addLimitAnnouncements() async {
    if (_canGetMoreAnnouncement) {
      try {
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
    return null;
  }

  void incTotalViews(String id) async {
    if (!viewsAnnouncements.contains(id)) {
      dbManager.incTotalViewsById(id);
      viewsAnnouncements.add(id);
    }
  }

  Future<void> loadSearchAnnouncement(String? searchText, bool isNew) async{
    if (_canGetMoreSearchAnnouncement) {
      try {
        searchAnnouncements = isNew ? [] : searchAnnouncements;

        searchAnnouncements.addAll(await dbManager.searchLimitAnnouncements(_searchLastId, searchText));
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
}
