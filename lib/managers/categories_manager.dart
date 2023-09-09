import '../../models/models.dart';
import '../services/database_service.dart';

class CategoriesManager {
  final DatabaseService databaseManger;

  CategoriesManager({required this.databaseManger});

  List<Category> categories = [];
  List<Subcategory> subcategories = [];

  Future loadCategories() async =>
      categories = await databaseManger.getAllCategories();

  Future loadSubcategory(String categoryID) async => subcategories =
      await databaseManger.getAllSubCategoriesByCategoryId(categoryID);
}
