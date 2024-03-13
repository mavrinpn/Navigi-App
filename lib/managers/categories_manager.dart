import 'package:smart/services/database/database_service.dart';

import '../../models/models.dart';

class CategoriesManager {
  final DatabaseService databaseService;

  CategoriesManager({required this.databaseService});

  Future<List<Category>> loadCategories() async =>
      databaseService.categories.getAllCategories();

  Future<List<Subcategory>> loadSubcategoriesByCategory(
          String categoryID) async =>
      databaseService.categories.getAllSubcategoriesFromCategoryId(categoryID);

  Future<List<Subcategory>> tryToLoadSubcategoriesBuSubcategory(
          String subcategoryId) async =>
      databaseService.categories.getSubcategoriesBySubcategory(subcategoryId);

  Future getFilters(String subcategoryId) async =>
      databaseService.categories.getSubcategoryParameters(subcategoryId);

  Future<({Subcategory subcategory, Category category})> getSubcategory(
          String subcategoryId) async =>
      databaseService.categories.getSubcategyById(subcategoryId);
}
