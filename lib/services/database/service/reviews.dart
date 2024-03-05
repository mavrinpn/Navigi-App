part of '../database_service.dart';

class ReviewsService {
  final Databases _databases;

  static const String activeAttribute = 'active';

  ReviewsService(Databases databases, Storage storage) : _databases = databases;

  Future<List<Review>> getReviewsBy(String receiverId) async {
    List<String> queries = [];

    queries.add(Query.equal('receiverId', receiverId));

    final res = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: reviewsCollection,
      queries: queries,
    );

    List<Review> result = [];
    for (var doc in res.documents) {
      result.add(Review.fromJson(doc.data));
    }

    return result;
  }

  Future<void> create({
    required String creatorId,
    required String receiverId,
    required int score,
    required String text,
  }) async {
    final data = <String, dynamic>{
      'creatorId': creatorId,
      'creator': creatorId,
      'text': text,
      'receiverId': receiverId,
      'score': score,
    };

    await _databases.createDocument(
      databaseId: mainDatabase,
      collectionId: reviewsCollection,
      documentId: ID.unique(),
      data: data,
    );
  }
}
