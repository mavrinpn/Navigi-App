import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoadingStateEnum {wait, loading, success, fail}
enum AuthStateEnum {wait, loading, auth, unAuth}

class AppRepository {
  final Client client;
  final Account account;
  late User user;
  String? sessionID;

  static const sessionIdKey = 'sessionID';

  AppRepository({required this.client}) : account = Account(client);

  BehaviorSubject<AuthStateEnum> authState = BehaviorSubject<AuthStateEnum>.seeded(AuthStateEnum.wait);

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

  void registerWithEmail({required String email, required String password, required String name}) async {
    await account.create(userId: ID.unique(), email: email, password: password, name: name);
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
}
