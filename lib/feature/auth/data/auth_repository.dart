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

  void logout() async {
    await _account.deleteSession(sessionId: sessionID!);
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    authState.add(EntranceStateEnum.wait);
    _messagingService.userId = null;
    appState.add(AuthStateEnum.unAuth);
  }

  String _tempMail = '';

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

  Future<String?> _getEmailByPhone(String phone) async {
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
    final String? email = await _getEmailByPhone(phone);
    if (email != null) {
      await _account.create(
          userId: ID.unique(), email: email, password: password, name: 'Guest');
      print('create account $email $password');
    }
    await _account.createEmailSession(
        email: email ?? _tempMail, password: password);
  }

  Future<void> _authorizeWithCredentials(UserCredentials credentials) async {
    final promise = await _account.createEmailSession(
        email: credentials.mail, password: credentials.password);
    _user = await _account.get();

    await _saveSessionId(promise.$id);
    await _preloadUserDataAndCreateIfNeed(credentials.mail);
    _initMessaging();
  }

  Future _saveSessionId(String newSessionId) async {
    sessionID = newSessionId;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(sessionIdKey, sessionID!);
  }

  Future _preloadUserDataAndCreateIfNeed(String email) async {
    final result = await getUserData();
    if (!result) {
      await _createUserData(email);
      getUserData();
    }
  }

  Future _createUserData(String email) async {
    final phone = email.split('@')[0];

    await _databaseService.users
        .createUser(name: 'Guest', uid: userId, phone: phone);
  }
}
