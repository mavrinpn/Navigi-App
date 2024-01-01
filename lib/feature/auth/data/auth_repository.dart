import 'dart:async';
import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/models/user.dart';
import 'package:smart/services/database/database_service.dart';
import 'package:smart/services/messaging_service.dart';
import 'package:smart/services/storage_service.dart';
import 'package:uuid/uuid.dart';

import '../../../enum/enum.dart';

class AuthRepository {
  final Client client;
  final Account _account;
  final DatabaseService _databaseService;
  final MessagingService _messagingService;
  final FileStorageManager _fileStorageManager;

  late User _user;
  late UserData userData;
  String? sessionID;
  static const sessionIdKey = 'sessionID';

  String get userId => _user.$id;

  AuthRepository(
      {required this.client,
      required DatabaseService databaseService,
      required MessagingService messagingService,
      required FileStorageManager fileStorageManager})
      : _account = Account(client),
        _fileStorageManager = fileStorageManager,
        _messagingService = messagingService,
        _databaseService = databaseService {
    checkLogin();
  }

  BehaviorSubject<bool> refresherStream = BehaviorSubject();

  BehaviorSubject<EntranceStateEnum> authState =
      BehaviorSubject<EntranceStateEnum>.seeded(EntranceStateEnum.wait);

  BehaviorSubject<AuthStateEnum> appState =
      BehaviorSubject<AuthStateEnum>.seeded(AuthStateEnum.wait);

  BehaviorSubject<LoadingStateEnum> profileState =
      BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.loading);

  static String convertPhoneToEmail(String phone) {
    const id = Uuid();

    return '89$phone@${id.v1()}.ru';
    // return '$phone@gmail.com';
  }

  Future<void> _initMessaging() async {
    _messagingService.userId = _user.$id;
    _messagingService.initNotification();
    _messagingService.handleTokenRefreshing();
  }

  // Future<void> _auth(Future<Session> method, {Future? requiredMethod}) async {
  //   authState.add(EntranceStateEnum.loading);
  //   try {
  //     final promise = await method;
  //     sessionID = promise.$id;
  //
  //     final prefs = await SharedPreferences.getInstance();
  //     prefs.setString(sessionIdKey, sessionID!);
  //
  //     _user = await _account.get();
  //     if (requiredMethod != null) {
  //       await requiredMethod;
  //     }
  //     authState.add(EntranceStateEnum.success);
  //     getUserData();
  //     _initMessaging();
  //     appState.add(AuthStateEnum.auth);
  //   } catch (e) {
  //     authState.add(EntranceStateEnum.fail);
  //     rethrow;
  //   }
  // }

  void logout() async {
    await _account.deleteSession(sessionId: sessionID!);
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    authState.add(EntranceStateEnum.wait);
    _messagingService.userId = null;
    appState.add(AuthStateEnum.unAuth);
  }

  // void registerWithEmail(
  //     {required String email, required String password}) async {
  //   final User res;
  //
  //   try {
  //     res = await _account.create(
  //         userId: ID.unique(), email: email, password: password, name: 'Guest');
  //   } catch (e) {
  //     authState.add(EntranceStateEnum.alreadyExist);
  //     return;
  //   }
  //
  //   await _auth(_account.createEmailSession(email: email, password: password),
  //       requiredMethod: _databaseService.users
  //           .createUser(name: res.name, uid: res.$id, phone: email));
  // }
  //
  // void loginWithEmail({required String email, required String password}) =>
  //     _auth(_account.createEmailSession(email: email, password: password));

  String _tempMail = '';

  Future<String?> _getEmail(String phone) async {
    final String? email;
    if (!_tempMail.startsWith('89$phone')) {
      email = convertPhoneToEmail(phone);
      _tempMail = email;
    } else {
      email = null;
    }
    return email;
  }

  Future _createTempAccount(String phone) async {
    const String password = 'temppassword123';
    final String? email = await _getEmail(phone);
    if (email != null) {
      await _account.create(
          userId: ID.unique(), email: email, password: password, name: 'Guest');
      print('create account $email $password');
    }
    await _account.createEmailSession(
        email: email ?? _tempMail, password: password);
  }

  Future<void> createAccountAndSendSms(String phone) async {
    await _createTempAccount(phone);
    await _databaseService.users.sendSms();
  }

  Future<void> confirmCode(String code) async {
    authState.add(EntranceStateEnum.loading);
    try {
      final res = await _databaseService.users.confirmSms(code);
      await _authorizeWithCredentials(res!);

      authState.add(EntranceStateEnum.success);
      appState.add(AuthStateEnum.auth);
    } catch (e) {
      authState.add(EntranceStateEnum.fail);
      rethrow;
    }
  }

  Future<void> _authorizeWithCredentials(UserCredentials credentials) async {
    final promise = await _account.createEmailSession(
        email: credentials.mail, password: credentials.password);

    sessionID = promise.$id;
    _user = await _account.get();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(sessionIdKey, sessionID!);

    final result = await getUserData();
    if (!result) {
      await _createUserData(credentials.mail);
      getUserData();
    }

    _initMessaging();
  }

  Future _createUserData(String email) async {
    final phone = email.split('@')[0];

    await _databaseService.users
        .createUser(name: 'Guest', uid: userId, phone: phone);
  }

  void checkLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      sessionID = prefs.getString(sessionIdKey);
      if (sessionID != null) {
        _user = await _account.get();
        getUserData();
        _initMessaging();
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
      await _databaseService.users.editProfile(
          uid: _user.$id, name: name, phone: phone, imageUrl: imageUrl);
    } catch (e) {
      profileState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }

  Future<bool> getUserData() async {
    profileState.add(LoadingStateEnum.loading);
    try {
      final res = await _databaseService.users.getUserData(uid: _user.$id);
      if (res != null) {
        userData = res;
      } else {
        return false;
      }

      profileState.add(LoadingStateEnum.success);
      return true;
    } catch (e) {
      profileState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }
}
