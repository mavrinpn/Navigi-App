part of '../database_service.dart';

class ReviewsService {
  final Databases _databases;
  final Functions _functions;
  final Account _account;

  static const String activeAttribute = 'active';
  final sendReviewFunc = '663cea408ba6e04d8134';

  ReviewsService(
    Databases databases,
    Storage storage,
    Functions functions,
    Account account,
  )   : _databases = databases,
        _account = account,
        _functions = functions;

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

  Future<String> getJwt() => _account.createJWT().then((value) => value.jwt);

  Future<String?> create({
    required String creatorId,
    required String receiverId,
    required int score,
    required String text,
  }) async {
    final jwt = await getJwt();
    final body = jsonEncode({
      'jwt': jwt,
      'score': score,
      'text': text,
      'receiver_id': receiverId,
    });

    final res = await _functions.createExecution(
      functionId: sendReviewFunc,
      body: body,
    );
    final resBody = jsonDecode(res.responseBody);
    return resBody['status'] != null ? resBody['status'] as String : '';
  }
}
