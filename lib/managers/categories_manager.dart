import 'package:smart/services/database/database_service.dart';

import '../../models/models.dart';

class CategoriesManager {
  final DatabaseService databaseService;

  CategoriesManager({required this.databaseService});

  List<Category> categories = [];
  List<Subcategory> subcategories = [];

  Future loadCategories() async =>
      categories = await databaseService.categories.getAllCategories();

  Future loadSubcategory(String categoryID) async => subcategories =
      await databaseService.categories.getAllSubcategoriesFromCategoryId(categoryID);
}
