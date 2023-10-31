import '../../models/models.dart';
import '../services/database_service.dart';

class CategoriesManager {
  final DatabaseService databaseService;

  CategoriesManager({required this.databaseService});

  List<Category> categories = [];
  List<Subcategory> subcategories = [];

  Future loadCategories() async =>
      categories = await databaseService.getAllCategories();

  Future loadSubcategory(String categoryID) async => subcategories =
      await databaseService.getAllSubcategoriesFromCategoryId(categoryID);
}
