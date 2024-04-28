part of '../database_service.dart';

class TipWordsService {
  final Databases _databases;

  TipWordsService(Databases databases) : _databases = databases;

  Future<List<TipWord>> searchByLastWord({
    required String subcategoryId,
    required String? query,
    required String? markId,
    required String? modelId,
    required String? previousWordId,
    required String? previousWordGroupId,
  }) async {
    List<String> queries = [];

    queries.add(Query.limit(40));
    queries.add(Query.equal('subcategory_id', subcategoryId));
    if (markId != null) {
      queries.add(Query.equal('mark', markId));
    }
    if (modelId != null) {
      queries.add(Query.equal('model', modelId));
    }

    if (query != null) {
      queries.add(Query.or([
        Query.equal('full_tip', false),
        Query.isNull('full_tip'),
      ]));

      queries.add(Query.or([
        Query.contains('nameAr', query),
        Query.contains('nameFr', query),
      ]));
    }

    if (previousWordId != null && previousWordGroupId != null) {
      final orQuery = Query.or([
        Query.equal('previousWordId', previousWordId),
        Query.equal('previousWordGroupId', previousWordGroupId),
      ]);
      queries.add(orQuery);
    } else {
      if (previousWordId != null) {
        queries.add(Query.equal('previousWordId', previousWordId));
      }

      if (previousWordGroupId != null) {
        queries.add(Query.equal('previousWordGroupId', previousWordGroupId));
      }
    }

    final res = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: tipWordsCollection,
      queries: queries,
    );

    List<TipWord> result = [];
    for (var doc in res.documents) {
      result.add(TipWord.fromJson(doc.data));
    }
    return result;
  }

  Future<List<TipWord>> searchByWholeString({
    required String subcategoryId,
    required String query,
    required String? markId,
    required String? modelId,
  }) async {
    List<String> queries = [];

    queries.add(Query.limit(40));
    queries.add(Query.equal('subcategory_id', subcategoryId));
    if (markId != null) {
      queries.add(Query.equal('mark', markId));
    }
    if (modelId != null) {
      queries.add(Query.equal('model', modelId));
    }

    queries.add(Query.equal('full_tip', true));

    queries.add(Query.or([
      Query.contains('nameAr', query),
      Query.contains('nameFr', query),
    ]));

    final res = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: tipWordsCollection,
      queries: queries,
    );

    List<TipWord> result = [];
    for (var doc in res.documents) {
      result.add(TipWord.fromJson(doc.data));
    }
    return result;
  }
}
