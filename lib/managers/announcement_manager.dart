import 'package:appwrite/appwrite.dart';
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
  bool _canGetMoreAnnouncement = true;

  List<String> viewsAnnouncements = [];
  List<String> contactsAnnouncements = [];
  List<Announcement> announcements = [];
  List<Announcement> searchAnnouncements = [];
  Announcement? lastAnnouncement;

  BehaviorSubject<LoadingStateEnum> announcementsLoadingState = BehaviorSubject.seeded(LoadingStateEnum.loading);

  Future<void> addLimitAnnouncements(bool isNew) async {
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
        }

        final newAnnouncements = await dbService.announcements.getAnnouncements(
          lastId: _lastId,
          excudeUserId: uid,
        );

        announcements.addAll(newAnnouncements);
        _lastId = announcements.last.anouncesTableId;
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
    try {
      if (isNew) {
        searchAnnouncements.clear();
        _searchLastId = '';
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

      searchAnnouncements.addAll(await dbService.announcements.searchAnnouncementsInSubcategory(filter));

      _searchLastId = searchAnnouncements.last.subTableId;
    } catch (e) {
      if (e.toString() != 'Bad state: No element') {
        rethrow;
      }
    }
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
