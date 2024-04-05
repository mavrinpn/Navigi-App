part of '../database_service.dart';

class CategoriesService {
  final Databases _databases;

  CategoriesService(Databases databases) : _databases = databases;

  Future<List<Category>> getAllCategories() async {
    final res = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: categoriesCollection,
    );

    List<Category> categories = [];
    for (var doc in res.documents) {
      categories.add(Category.fromJson(doc.data));
    }

    return categories;
  }

  Future<List<Subcategory>> getAllSubcategoriesFromCategoryId(
    String categoryID,
  ) async {
    List<Subcategory> subcategories = <Subcategory>[];
    final res = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: subcategoriesCollection,
      queries: [
        Query.equal(categoryId, categoryID),
        Query.limit(1000),
      ],
    );

    for (var doc in res.documents) {
      subcategories.add(Subcategory.fromJson(doc.data));
    }

    subcategories.sort((a, b) => a.weight.compareTo(b.weight));
    return subcategories;
  }

  Future<Map<String, dynamic>> getSubcategoryParameters(
      String subcategory) async {
    final res = await _databases.getDocument(
        databaseId: mainDatabase,
        collectionId: 'categoryFilters',
        documentId: subcategory);

    final decodedParameters = jsonDecode(res.data['parameters']);
    return decodedParameters;
  }

  Future<List<Subcategory>> getSubcategoriesBySubcategory(
      String subcategoryID) async {
    List<Subcategory> subcategories = <Subcategory>[];
    final res = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: subcategoriesCollection,
      queries: [
        Query.equal('subcategoryId', subcategoryID),
        Query.limit(1000),
      ],
    );

    for (var doc in res.documents) {
      subcategories.add(Subcategory.fromJson(doc.data));
    }
    subcategories.sort((a, b) => a.weight.compareTo(b.weight));
    return subcategories;
  }

  Future<({Subcategory subcategory, Category category})> getSubcategyById(
      String subcategoryID) async {
    final subcategoryDoc = await _databases.getDocument(
      databaseId: mainDatabase,
      collectionId: subcategoriesCollection,
      documentId: subcategoryID,
    );

    final subcategory = Subcategory.fromJson(subcategoryDoc.data);

    final categoryId = subcategory.categoryId;
    final categoryDoc = await _databases.getDocument(
      databaseId: mainDatabase,
      collectionId: categoriesCollection,
      documentId: categoryId,
    );
    final category = Category.fromJson(categoryDoc.data);

    return (subcategory: subcategory, category: category);
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

  // Future<List<CityDistrict>> getAllPlaces() async {
  //   final res = await _databases.listDocuments(
  //       databaseId: mainDatabase, collectionId: placeCollection);

  //   List<CityDistrict> places = [];
  //   for (var doc in res.documents) {
  //     places.add(CityDistrict.fromJson(doc.data));
  //   }
  //   return places;
  // }

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
        collectionId: areaCollection,
        queries: [Query.equal('city_id', cityId)]);

    List<CityDistrict> places = [];
    for (var doc in res.documents) {
      places.add(CityDistrict.fromJson(doc.data));
    }
    return places;
  }

  // Future searchItemsByQuery(String query) async {
  //   final List<String> queries = [
  //     Query.search('name', query),
  //     Query.limit(40),
  //   ];
  //   final res = await _databases.listDocuments(
  //       databaseId: mainDatabase,
  //       collectionId: itemsCollection,
  //       queries: queries);
  //   List<SubcategoryItem> items = [];
  //   for (var doc in res.documents) {
  //     items.add(SubcategoryItem.fromJson(doc.data));
  //   }
  //   return items;
  // }

  Future getKeyWords({
    required String name,
    required String? subcategoryId,
  }) async {
    List<String> queries = [
      Query.or([
        Query.search('nameAr', name),
        Query.search('nameFr', name),
      ]),
      Query.limit(40),
    ];
    if (subcategoryId != null) {
      queries.add(
        Query.equal('subcategory_id', subcategoryId),
      );
    }
    final res = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: keyWordsCollection,
      queries: queries,
    );
    List<KeyWord> items = [];
    for (var doc in res.documents) {
      items.add(KeyWord.fromJson(doc.data));
    }
    return items;
  }

  Future<List<String>> getPopularQueries() async {
    final res = await _databases.listDocuments(
        databaseId: mainDatabase, collectionId: 'queries');

    return res.documents.map((e) => e.data['name'].toString()).toList();
  }

  // Future<SubcategoryItem?> getItem(String itemId) async {
  //   final res = await _databases.getDocument(
  //       databaseId: mainDatabase,
  //       collectionId: itemsCollection,
  //       documentId: itemId);

  //   return SubcategoryItem(
  //       name: res.data['name'],
  //       id: res.$id,
  //       subcategoryId: res.data['subcategory']);
  // }

  Future<List<Mark>> getCarMarks(String subcategory) async {
    final res = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: 'manufacturerSubcategory',
        queries: [
          Query.equal('subcategoryId', subcategory),
          Query.limit(1000)
        ]);

    List<Mark> marks = <Mark>[];
    for (var i in res.documents) {
      if (i.data['manufacturers'] != null) {
        marks.add(
          Mark(
            id: i.data['manufacturers']['\$id'],
            name: i.data['manufacturers']['name'],
            image: i.data['manufacturers']['image'],
          ),
        );
      }
    }

    marks.sort((a, b) => a.name.compareTo(b.name));

    return marks;
  }

  // Future<List<Mark>> getCarMarks() async {
  //   final res = await _databases.listDocuments(
  //     databaseId: mainDatabase,
  //     collectionId: 'manufacturers',
  //     queries: [
  //       Query.limit(1000),
  //     ],
  //   );

  //   List<Mark> marks = <Mark>[];
  //   for (var i in res.documents) {
  //     marks.add(Mark(i.$id, i.data['name']));
  //   }

  //   marks.sort((a, b) => a.name.compareTo(b.name));

  //   return marks;
  // }

  Future<List<Mark>> getSubcategoryMarks(String subcategory) async {
    final res = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: 'manufacturerSubcategory',
        queries: [
          Query.equal('subcategoryId', subcategory),
          Query.limit(1000)
        ]);

    List<Mark> marks = <Mark>[];
    for (var i in res.documents) {
      if (i.data['manufacturers'] != null) {
        marks.add(
          Mark(
            id: i.data['manufacturers']['\$id'],
            name: i.data['manufacturers']['name'],
            image: i.data['manufacturers']['image'],
          ),
        );
      }
    }

    marks.sort((a, b) => a.name.compareTo(b.name));

    return marks;
  }

  Future<List<MarkModel>> getSubcategoryMarksModels({
    required String subcategory,
    required String mark,
  }) async {
    final query = [
      Query.equal('subcategoryId', subcategory),
      Query.equal('manufacturerId', mark),
      Query.limit(1000)
    ];

    final res = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: 'models',
      queries: query,
    );

    List<MarkModel> models = <MarkModel>[];
    for (var i in res.documents) {
      models.add(MarkModel(i.$id, i.data['name'], i.data['parameters']));
    }

    models.sort((a, b) => a.name.compareTo(b.name));

    return models;
  }

  Future<List<CarModel>> getCarModels({
    required String subcategory,
    required String mark,
  }) async {
    final query = [
      Query.equal('subcategoryId', subcategory),
      Query.equal('manufacturerId', mark),
      Query.limit(1000)
    ];

    final res = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: 'models',
      queries: query,
    );

    List<CarModel> models = <CarModel>[];
    for (var doc in res.documents) {
      String paramsString = doc.data['parameters'] as String;
      //* remove replaceAll
      paramsString = paramsString.replaceAll("'", '"');
      final params = jsonDecode(paramsString) as List;

      String complectations = '';
      String engines = '';
      for (var param in params) {
        final paramMap = param as Map<String, dynamic>;
        final id = paramMap['id'] as String;
        if (id == 'complectation') {
          final type = paramMap['type'] as String;
          if (type == 'option') {
            final options = paramMap['options'] as List;
            complectations = jsonEncode(options);
          }
        } else if (id == 'engine') {
          final type = paramMap['type'] as String;
          if (type == 'option') {
            final options = paramMap['options'] as List;
            engines = jsonEncode(options);
          }
        }
      }

      models.add(
        CarModel(
          doc.$id,
          doc.data['name'],
          complectations,
          engines,
        ),
      );
    }

    models.sort((a, b) => a.name.compareTo(b.name));

    return models;
  }

  // Future<List<CarModel>> getCarModels(String markId) async {
  //   final res = await _databases.listDocuments(
  //       databaseId: mainDatabase,
  //       collectionId: 'models',
  //       queries: [Query.equal('markId', markId)]);

  //   List<CarModel> models = <CarModel>[];

  //   for (var doc in res.documents) {
  //     models.add(CarModel(doc.$id, doc.data['name'], doc.data['complectations'],
  //         doc.data['engines']));
  //   }

  //   models.sort((a, b) => a.name.compareTo(b.name));

  //   return models;
  // }
}
