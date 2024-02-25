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

  Future<Map<String, dynamic>> getSubcategoryParameters(
      String subcategory) async {
    print(subcategory);

    final res = await _databases.getDocument(
        databaseId: mainDatabase,
        collectionId: 'categoryFilters',
        documentId: subcategory);

    print(res.data);
    final decodedParameters = jsonDecode(res.data['parameters']);
    print(decodedParameters);
    return decodedParameters;
  }

  Future<List<Subcategory>> getSubcategoriesBySubcategory(
      String subcategoryID) async {
    List<Subcategory> subcategories = <Subcategory>[];
    final res = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: subcategoriesCollection,
        queries: [Query.equal('subcategoryId', subcategoryID)]);

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
      items.add(SubcategoryItem.fromJson(doc.data));
    }
    return items;
  }

  Future<List<CityDistrict>> getAllPlaces() async {
    final res = await _databases.listDocuments(
        databaseId: mainDatabase, collectionId: placeCollection);

    List<CityDistrict> places = [];
    for (var doc in res.documents) {
      places.add(CityDistrict.fromJson(doc.data));
    }
    return places;
  }

  Future<List<City>> getAllCities() async {
    final res = await _databases.listDocuments(
        databaseId: mainDatabase, collectionId: citiesCollection);

    List<City> cities = [];
    for (var doc in res.documents) {
      cities.add(City.fromJson(doc.data));
    }
    return cities;
  }

  Future<List<CityDistrict>> getCityDistricts(String cityId) async {
    final res = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: cityDistrictsCollection,
        queries: [Query.equal('cityId', cityId)]);

    List<CityDistrict> places = [];
    for (var doc in res.documents) {
      places.add(CityDistrict.fromJson(doc.data));
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
        subcategoryId: res.data['subcategory']);
  }

  Future<List<Mark>> getAutoMarks() async {
    final res = await _databases.listDocuments(
        databaseId: mainDatabase, collectionId: 'autoMarks');

    final marks = <Mark>[];
    for (var i in res.documents) {
      marks.add(Mark(i.$id, i.data['name']));
    }

    return marks;
  }

  Future<List<Mark>> getSubcategoryMarks(String subcategory) async {
    final res = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: 'manufacturerSubcategory',
        queries: [Query.equal('subcategoryId', subcategory)]);

    final marks = <Mark>[];
    for (var i in res.documents) {
      print(i.data);
      marks.add(Mark(
          i.data['manufacturers']['\$id'], i.data['manufacturers']['name']));
    }

    return marks;
  }

  Future<List<MarkModel>> getSubcategoryMarksModels(
      String subcategory, String mark) async {
    final res = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: 'models',
        queries: [
          Query.equal('subcategoryId', subcategory),
          Query.equal('manufacturerId', mark)
        ]);

    final models = <MarkModel>[];
    for (var i in res.documents) {
      models.add(MarkModel(i.$id, i.data['name'], i.data['parameters']));
    }

    return models;
  }

  Future<List<AutoModel>> getAutoModels(String markId) async {
    final res = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: 'autoModels',
        queries: [Query.equal('markId', markId)]);

    final models = <AutoModel>[];

    for (var doc in res.documents) {
      models.add(AutoModel(doc.$id, doc.data['name'],
          doc.data['complectations'], doc.data['engines']));
    }

    return models;
  }
}
