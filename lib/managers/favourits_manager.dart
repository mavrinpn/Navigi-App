import 'package:rxdart/rxdart.dart';
import 'package:smart/enum/enum.dart';

import '../models/announcement.dart';
import '../services/database_service.dart';

class FavouritesManager {
  final DatabaseService databaseService;

  String? userId;
  List<Announcement> announcements = [];

  bool contains(String id) {
    for (var i in announcements) {
      if (i.announcementId == id) return true;
    }
    return false;
  }

  FavouritesManager({required this.databaseService});

  BehaviorSubject<LoadingStateEnum> loadingState =
      BehaviorSubject.seeded(LoadingStateEnum.loading);

  Future<void> like(String postId) async =>
      await databaseService.likePost(postId: postId, userId: userId!);

  Future<void> unlike(String postId) async =>
      await databaseService.unlikePost(postId: postId, userId: userId!);

  Future<void> getFavourites() async {
    loadingState.add(LoadingStateEnum.loading);
    try {
      announcements =
          await databaseService.getFavouritesAnnouncements(userId: userId!);
      // print(announcements);
      loadingState.add(LoadingStateEnum.success);
    } catch (e) {
      loadingState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }
}
