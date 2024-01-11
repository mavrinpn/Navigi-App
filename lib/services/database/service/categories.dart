part of '../database_service.dart';

class CategoriesService {
  final Databases _databases;

  CategoriesService(Databases databases) : _databases = databases;

  Future<List<Category>> getAllCategories() async {
    final res = await _databases.listDocuments(
        databaseId: mainDatabase, collectionId: categoriesCollection);

    List<Category> categories = [];
    for (var doc in res.documents) {
      categories.add(Category.fromJson(doc.data));
    }

    return categories;
  }

  Future<List<Subcategory>> getAllSubcategoriesFromCategoryId(
      String categoryID) async {
    List<Subcategory> subcategories = <Subcategory>[];
    final res = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: subcategoriesCollection,
        queries: [Query.equal(categoryId, categoryID)]);

    for (var doc in res.documents) {
      subcategories.add(Subcategory.fromJson(doc.data));
    }
    return subcategories;
  }

  Future<List<SubcategoryItem>> getItemsFromSubcategory(
      String subcategory) async {
    final res = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: itemsCollection,
        queries: [Query.equal(subcategoryId, subcategory)]);
    List<SubcategoryItem> items = [];
    for (var doc in res.documents) {
      items.add(SubcategoryItem.fromJson(doc.data)..initialParameters());
    }
    return items;
  }

  Future<List<PlaceData>> getAllPlaces() async {
    final res = await _databases.listDocuments(
        databaseId: mainDatabase, collectionId: placeCollection);

    List<PlaceData> places = [];
    for (var doc in res.documents) {
      places.add(PlaceData.fromJson(doc.data));
    }
    return places;
  }

  Future searchItemsByQuery(String query) async {
    final List<String> queries = [
      Query.search('name', query),
      Query.limit(40),
    ];
    final res = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: itemsCollection,
        queries: queries);
    List<SubcategoryItem> items = [];
    for (var doc in res.documents) {
      items.add(SubcategoryItem.fromJson(doc.data));
    }
    return items;
  }

  Future<List<String>> getPopularQueries() async {
    final res = await _databases.listDocuments(
        databaseId: mainDatabase, collectionId: 'queries');

    return res.documents.map((e) => e.data['name'].toString()).toList();
  }

  Future<SubcategoryItem?> getItem(String itemId) async {
    final res = await _databases.getDocument(
        databaseId: mainDatabase,
        collectionId: itemsCollection,
        documentId: itemId);

    return SubcategoryItem(
        name: res.data['name'],
        id: res.$id,
        subcategoryId: res.data['subcategory'],
        parameters: res.data['parametrs']);
  }
}
