import 'package:appwrite/appwrite.dart';
import 'package:smart/models/review.dart';
import 'package:smart/services/database/database_service.dart';

class ReviewsManager {
  final DatabaseService databaseService;
  final Client client;
  final Account account;

  ReviewsManager({
    required this.databaseService,
    required this.client,
  }) : account = Account(client);

  Future<List<Review>> loadBy(String receiverId) async =>
      databaseService.reviews.getReviewsBy(receiverId);

  Future<void> newReview({
    required String receiverId,
    required int score,
    required String text,
  }) async {
    final user = await account.get();
    final uid = user.$id;

    databaseService.reviews.create(
      creatorId: uid,
      receiverId: receiverId,
      score: score,
      text: text,
    );
  }
}
