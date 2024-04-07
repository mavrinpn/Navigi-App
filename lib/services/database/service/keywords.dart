part of '../database_service.dart';

class KeyWordsService {
  final Databases _databases;

  KeyWordsService(Databases databases) : _databases = databases;

  Future<List<KeyWord>> searchBy({
    required String subcategoryId,
    required String query,
  }) async {
    List<String> queries = [
      Query.or([
        Query.contains('nameAr', query),
        Query.contains('nameFr', query),
      ]),
      Query.limit(40),
    ];

    queries.add(Query.equal('subcategory_id', subcategoryId));

    final res = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: keyWordsCollection,
      queries: queries,
    );

    List<KeyWord> result = [];
    for (var doc in res.documents) {
      result.add(KeyWord.fromJson(doc.data));
    }

    return result;
  }
  // Future<List<KeyWord>> searchByFr({
  //   required String subcategoryId,
  //   required String query,
  // }) async {
  //   List<String> queries = [];

  //   queries.add(Query.equal('subcategory_id', subcategoryId));

  //   queries.add(Query.equal('subcategory_id', subcategoryId));
  //   queries.add(Query.startsWith('nameFr', query));

  //   final res = await _databases.listDocuments(
  //     databaseId: mainDatabase,
  //     collectionId: keyWordsCollection,
  //     queries: queries,
  //   );

  //   List<KeyWord> result = [];
  //   for (var doc in res.documents) {
  //     result.add(KeyWord.fromJson(doc.data));
  //   }

  //   return result;
  // }

  // Future<List<KeyWord>> searchByAr({
  //   required String subcategoryId,
  //   required String query,
  // }) async {
  //   List<String> queries = [];

  //   queries.add(Query.equal('subcategory_id', subcategoryId));

  //   queries.add(Query.equal('subcategory_id', subcategoryId));
  //   queries.add(Query.startsWith('nameAr', query));

  //   final res = await _databases.listDocuments(
  //     databaseId: mainDatabase,
  //     collectionId: keyWordsCollection,
  //     queries: queries,
  //   );

  //   List<KeyWord> result = [];
  //   for (var doc in res.documents) {
  //     result.add(KeyWord.fromJson(doc.data));
  //   }

  //   return result;
  // }
}
