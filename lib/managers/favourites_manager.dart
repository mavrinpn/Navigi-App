import 'package:rxdart/rxdart.dart';
import 'package:smart/enum/enum.dart';
import 'package:smart/services/database/database_service.dart';

import '../models/announcement.dart';

class FavouritesManager {
  final DatabaseService databaseService;

  FavouritesManager({required this.databaseService});

  String? userId;
  List<Announcement> announcements = [];

  bool contains(String id) {
    for (var i in announcements) {
      if (i.anouncesTableId == id) return true;
    }
    return false;
  }

  BehaviorSubject<LoadingStateEnum> loadingState =
      BehaviorSubject.seeded(LoadingStateEnum.loading);

  Future<void> like(String postId) async => await databaseService.favourites
      .likePost(postId: postId, userId: userId!);

  Future<void> unlike(String postId) async => await databaseService.favourites
      .unlikePost(postId: postId, userId: userId!);

  Future<int> count(String postId) async =>
      await databaseService.favourites.countLikes(postId: postId);

  Future<void> getFavourites() async {
    loadingState.add(LoadingStateEnum.loading);
    try {
      announcements = await databaseService.favourites
          .getFavouritesAnnouncements(userId: userId!);
      loadingState.add(LoadingStateEnum.success);
    } catch (e) {
      loadingState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }
}
