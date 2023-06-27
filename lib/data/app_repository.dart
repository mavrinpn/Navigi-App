import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/models/category.dart';

import '../models/subCategory.dart';

enum LoadingStateEnum { wait, loading, success, fail }

enum AuthStateEnum { wait, loading, auth, unAuth }

class AppRepository {
  final Client client;
  final Account account;
  final Databases databases;
  late User user;
  String? sessionID;
  List<Category> categories = [];
  List<SubCategory> subcategories = [];

  static const sessionIdKey = 'sessionID';

  AppRepository({required this.client})
      : account = Account(client),
        databases = Databases(client) {
    checkLogin();
    loadCategories();
  }

  BehaviorSubject<AuthStateEnum> authState =
      BehaviorSubject<AuthStateEnum>.seeded(AuthStateEnum.wait);
  BehaviorSubject<LoadingStateEnum> categoriesState =
      BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);
  BehaviorSubject<LoadingStateEnum> subCategoriesState =
      BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);

  static String convertPhoneToEmail(String phone) {
    return '$phone@gmail.com';
  }

  void _auth(Future<Session> method) async {
    authState.add(AuthStateEnum.loading);
    try {
      final promise = await method;
      sessionID = promise.$id;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(sessionIdKey, sessionID!);
      user = await account.get();
      authState.add(AuthStateEnum.auth);
    } catch (e) {
      authState.add(AuthStateEnum.unAuth);
      rethrow;
    }
  }

  void logout() async {
    await account.deleteSession(sessionId: sessionID!);
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    authState.add(AuthStateEnum.unAuth);
  }

  void registerWithEmail(
      {required String email,
      required String password,
      required String name}) async {
    await account.create(
        userId: ID.unique(), email: email, password: password, name: name);
    _auth(account.createEmailSession(email: email, password: password));
  }

  void loginWithEmail({required String email, required String password}) =>
      _auth(account.createEmailSession(email: email, password: password));

  void checkLogin() async {
    authState.add(AuthStateEnum.loading);
    try {
      final prefs = await SharedPreferences.getInstance();
      sessionID = prefs.getString(sessionIdKey);
      if (sessionID != null) {
        user = await account.get();
        authState.add(AuthStateEnum.auth);
      } else {
        authState.add(AuthStateEnum.unAuth);
      }
    } catch (e) {
      authState.add(AuthStateEnum.unAuth);
    }
  }

  Future loadCategories() async {
    categoriesState.add(LoadingStateEnum.loading);
    try {
      final res = await databases.listDocuments(
          databaseId: 'annonces', collectionId: 'categories');

      res.documents.forEach((element) {
        print(element.data);
      });
      categories = [];
      for (var doc in res.documents) {
        categories.add(mapToCategory(doc.data));
      }
      categoriesState.add(LoadingStateEnum.success);
    } catch (e) {
      categoriesState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }

  Future loadSubCategories(String categoryID) async {
    subCategoriesState.add(LoadingStateEnum.loading);
    try {
      subcategories = <SubCategory>[];
      final res = await databases.listDocuments(
          databaseId: 'annonces',
          collectionId: 'sub_categories',
          queries: [Query.equal('categorie_id', categoryID)]);
      for (var doc in res.documents) {
        subcategories.add(mapToSubCategory(doc.data));
      }
      subCategoriesState.add(LoadingStateEnum.success);
    } catch (e) {
      subCategoriesState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }

  Category mapToCategory(Map<String, dynamic> json) {
    return Category(
        imageUrl: json['image_url'], name: json['name'], id: json['\$id']);
  }

  SubCategory mapToSubCategory(Map<String, dynamic> json) {
    return SubCategory(
        name: json['name'], id: json['\$id'], categoryId: json['categorie_id']);
  }
}
