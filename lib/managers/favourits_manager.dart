import 'package:rxdart/rxdart.dart';
import 'package:smart/enum/enum.dart';

import '../models/announcement.dart';
import '../services/database_service.dart';

class FavouritesManager {
  final DatabaseService dbManager;

  String? userId;
  List<Announcement> announcements = [];

  FavouritesManager({required this.dbManager});

  BehaviorSubject<LoadingStateEnum> loadingState =
      BehaviorSubject.seeded(LoadingStateEnum.loading);

  Future<void> like(String postId) async =>
      await dbManager.likePost(postId: postId, userId: userId!);

  Future<void> unlike(String postId) async =>
      await dbManager.unlikePost(postId: postId, userId: userId!);

  Future<void> getFavourites() async {
    loadingState.add(LoadingStateEnum.loading);
    try {
      await Future.delayed(Duration(seconds: 1));
      loadingState.add(LoadingStateEnum.success);
    } catch (e) {
      loadingState.add(LoadingStateEnum.fail);
    }
  }
}
