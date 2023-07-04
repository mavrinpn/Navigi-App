import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/announcement.dart';
import '../models/category.dart';

enum LoadingStateEnum { wait, loading, success, fail }

enum AuthStateEnum {wait,  auth, unAuth }

const String postDatabase = 'annonces';
const String postCollection = 'anounces';
const String itemsCollection = 'items';
const String categoriesCollection = 'categories';
const String subcategoriesCollection = 'sub_categories';

class AppRepository {
  final Client client;
  final Account account;
  final Databases databases;
  late User user;
  String? sessionID;

  static const sessionIdKey = 'sessionID';

  AppRepository({required this.client})
      : account = Account(client),
        databases = Databases(client) {
    checkLogin();
  }

  BehaviorSubject<LoadingStateEnum> authState =
      BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);

  BehaviorSubject<AuthStateEnum> appState = BehaviorSubject<AuthStateEnum>.seeded(AuthStateEnum.wait);

  static String convertPhoneToEmail(String phone) {
    return '$phone@gmail.com';
  }

  void _auth(Future<Session> method) async {
    authState.add(LoadingStateEnum.loading);
    try {
      final promise = await method;
      sessionID = promise.$id;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(sessionIdKey, sessionID!);
      user = await account.get();
      authState.add(LoadingStateEnum.success);
      appState.add(AuthStateEnum.auth);
    } catch (e) {
      authState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }

  void logout() async {
    await account.deleteSession(sessionId: sessionID!);
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    authState.add(LoadingStateEnum.wait);
    appState.add(AuthStateEnum.unAuth);
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
    try {
      final prefs = await SharedPreferences.getInstance();
      sessionID = prefs.getString(sessionIdKey);
      if (sessionID != null) {
        user = await account.get();
        appState.add(AuthStateEnum.auth);
      } else {
        appState.add(AuthStateEnum.unAuth);
      }
    } catch (e) {
      appState.add(AuthStateEnum.unAuth);
    }
  }
}
