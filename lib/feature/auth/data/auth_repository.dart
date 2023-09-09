import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/models/user.dart';
import 'package:smart/services/database_service.dart';
import 'package:smart/services/storage_service.dart';

import '../../../enum/enum.dart';

class AuthRepository {
  final Client client;
  final Account _account;
  final DatabaseService _databaseManger;
  final FileStorageManager _fileStorageManager;

  late User _user;
  late UserData userData;

  String? sessionID;

  static const sessionIdKey = 'sessionID';

  String get userId => _user.$id;

  AuthRepository(
      {required this.client,
      required DatabaseService databaseManger,
      required FileStorageManager fileStorageManager})
      : _account = Account(client),
        _fileStorageManager = fileStorageManager,
        _databaseManger = databaseManger {
    checkLogin();
  }

  BehaviorSubject<EntranceStateEnum> authState =
      BehaviorSubject<EntranceStateEnum>.seeded(EntranceStateEnum.wait);

  BehaviorSubject<AuthStateEnum> appState =
      BehaviorSubject<AuthStateEnum>.seeded(AuthStateEnum.wait);

  BehaviorSubject<LoadingStateEnum> profileState =
      BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.loading);

  static String convertPhoneToEmail(String phone) {
    return '$phone@gmail.com';
  }

  Future<void> _auth(Future<Session> method, {Future? requiredMethod}) async {
    authState.add(EntranceStateEnum.loading);
    try {
      final promise = await method;
      sessionID = promise.$id;

      final prefs = await SharedPreferences.getInstance();
      prefs.setString(sessionIdKey, sessionID!);

      _user = await _account.get();
      if (requiredMethod != null) {
        await requiredMethod;
      }
      authState.add(EntranceStateEnum.success);
      getUserData();
      appState.add(AuthStateEnum.auth);
    } catch (e) {
        authState.add(EntranceStateEnum.fail);
      rethrow;
    }
  }

  void logout() async {
    await _account.deleteSession(sessionId: sessionID!);
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    authState.add(EntranceStateEnum.wait);
    appState.add(AuthStateEnum.unAuth);
  }

  void registerWithEmail(
      {required String email,
      required String password,
      required String name}) async {
    final User res;

    try {
      res = await _account.create(
          userId: ID.unique(), email: email, password: password, name: name);
    } catch (e) {
      authState.add(EntranceStateEnum.alreadyExist);
      return;
    }

    await _auth(_account.createEmailSession(email: email, password: password),
        requiredMethod: _databaseManger.createUser(
            name: res.name, uid: res.$id, phone: email));
  }

  void loginWithEmail({required String email, required String password}) =>
      _auth(_account.createEmailSession(email: email, password: password));

  void checkLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      sessionID = prefs.getString(sessionIdKey);
      if (sessionID != null) {
        _user = await _account.get();
        getUserData();
        appState.add(AuthStateEnum.auth);
      } else {
        appState.add(AuthStateEnum.unAuth);
      }
    } catch (e) {
      appState.add(AuthStateEnum.unAuth);
    }
  }

  Future editProfile({String? name, String? phone, Uint8List? bytes}) async {
    profileState.add(LoadingStateEnum.loading);
    try {
      String? imageUrl;
      if (bytes != null) {
        imageUrl = await _fileStorageManager.uploadAvatar(bytes);
      }
      await _databaseManger.editProfile(
          uid: _user.$id, name: name, phone: phone, imageUrl: imageUrl);
    } catch (e) {
      profileState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }

  void getUserData() async {
    profileState.add(LoadingStateEnum.loading);
    try {
      userData = await _databaseManger.getUserData(uid: _user.$id);
      profileState.add(LoadingStateEnum.success);
    } catch (e) {
      profileState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }
}
