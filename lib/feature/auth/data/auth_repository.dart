import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/models/user.dart';
import 'package:smart/services/database/database_service.dart';
import 'package:smart/services/messaging_service.dart';
import 'package:smart/services/storage_service.dart';

import '../../../enum/enum.dart';

class AuthRepository {
  final Client client;
  final Account _account;
  final DatabaseService _databaseService;
  final MessagingService _messagingService;
  final FileStorageManager _fileStorageManager;

  User? _user;
  // String _tempMail = '';
  UserData? userData;
  String? sessionID;

  bool appMounted = true;

  static const Duration _onlineRefreshDuration = Duration(seconds: 30);
  void _timerFunction(Timer timer) {
    if (sessionID == null) {
      timer.cancel();
      return;
    }

    if (appMounted) _databaseService.users.updateOnlineStatus(userId);
  }

  void _startOnlineTimer() {
    Timer.periodic(_onlineRefreshDuration, _timerFunction);
  }

  static const sessionIdKey = 'sessionID';

  String get userId => _user?.$id ?? '';

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

  BehaviorSubject<EntranceStateEnum> authState = BehaviorSubject<EntranceStateEnum>.seeded(EntranceStateEnum.wait);

  BehaviorSubject<AuthStateEnum> appState = BehaviorSubject<AuthStateEnum>.seeded(AuthStateEnum.wait);

  BehaviorSubject<LoadingStateEnum> profileState = BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.loading);

  Future<void> _initMessaging() async {
    _messagingService.userId = _user?.$id ?? '';
    _messagingService.initNotification();
    _messagingService.handleTokenRefreshing();
  }

  void _initialize() async {
    getUserData();
    _initMessaging();
    _startOnlineTimer();
  }

  void checkLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      sessionID = prefs.getString(sessionIdKey);
      if (sessionID != null) {
        _user = await _account.get();
        _initialize();
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
        uid: _user?.$id ?? '',
        name: name,
        phone: phone,
        imageUrl: imageUrl,
      );
    } catch (e) {
      profileState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }

  Future<void> logout() async {
    //TODO user logout
    try {
      await _account.deleteSessions();
      sessionID = null;
      _user = null;
      userData = null;
    } catch (e) {
      log('session already deleted');
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    authState.add(EntranceStateEnum.wait);
    _messagingService.userId = null;
    appState.add(AuthStateEnum.unAuth);
  }

  Future<void> login(String email, String password) async {
    //TODO user login
    authState.add(EntranceStateEnum.loading);
    try {
      final credentials = UserCredentials(
        mail: email,
        password: password,
      );
      try {
        final sessions = await _account.listSessions();
        if (sessions.sessions.isNotEmpty) {
          _account.deleteSessions();
        }
      } catch (err) {
        // ignore: avoid_print
        print(err);
      }

      await _createSession(credentials);
      await _createUserData(
        email: credentials.mail,
        name: '',
        phone: '',
      );

      await getUserData();
      _initMessaging();
      _startOnlineTimer();

      authState.add(EntranceStateEnum.success);
      appState.add(AuthStateEnum.auth);
    } catch (err) {
      // ignore: avoid_print
      print(err);
      authState.add(EntranceStateEnum.fail);
    }
  }

  Future<void> createAccountAndSendSms({
    required String phone,
    required bool isPasswordRestore,
  }) async {
    await _createTempAccount(phone);
    await _databaseService.users.sendSms();
  }

  Future<void> createAccountAndSendEmailCode({
    required String email,
    required bool isPasswordRestore,
  }) async {
    await _createTempAccount(email);
    await _databaseService.users.sendEmailCode();
  }

  Future<void> confirmCode(
    String code, {
    required String password,
    required String name,
    required String phone,
    required bool isPasswordRestore,
  }) async {
    //TODO user register
    authState.add(EntranceStateEnum.loading);

    final (credentials, userExist) = await _databaseService.users.confirmCode(
      code,
      password,
    );
    if (userExist && !isPasswordRestore) {
      authState.add(EntranceStateEnum.alreadyExist);
    } else if (!userExist && isPasswordRestore) {
      authState.add(EntranceStateEnum.userNotFound);
    } else if (credentials != null) {
      await _account.deleteSessions();
      await _createSession(credentials);
      await _createUserData(
        email: credentials.mail,
        name: name,
        phone: phone,
      );

      await getUserData();
      _initMessaging();
      _startOnlineTimer();

      authState.add(EntranceStateEnum.success);
      appState.add(AuthStateEnum.auth);
    } else {
      authState.add(EntranceStateEnum.fail);
    }
  }

  Future<bool> getUserData() async {
    profileState.add(LoadingStateEnum.loading);
    try {
      final res = await _databaseService.users.getUserData(uid: _user?.$id ?? '');
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

  // Future<String?> _getEmailByPhone(String phone) async {
  //   final String? email;
  //   if (!_tempMail.startsWith('89$phone')) {
  //     email = convertPhoneToTempEmail(phone);
  //     _tempMail = email;
  //   } else {
  //     email = null;
  //   }
  //   return email;
  // }

  Future _createTempAccount(String email) async {
    const String password = 'temppassword123';
    //final String? email = await _getEmailByPhone(phone);
    try {
      await _account.deleteSessions();
    } catch (err) {
      // ignore: avoid_print
      print(err);
    }

    try {
      await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: 'Guest',
      );
    } catch (err) {
      // ignore: avoid_print
      print(err);
    }

    try {
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
    } catch (err) {
      // ignore: avoid_print
      print(err);
    }
  }

  // Future<void> _registerWithCredentials({
  //   required UserCredentials credentials,
  //   String? registrationName,
  //   required bool userExist,
  //   bool needRegister = false,
  // }) async {
  //   assert(!needRegister || needRegister && registrationName != null, 'for registration required name');

  //   await _createSession(credentials);

  //   if (userExist) {
  //     print('userExist');
  //     await _createSession(credentials);
  //   } else {
  //     print('user not Exist');
  //     await _createSession(credentials);
  //     // try {
  //     //   await _account.get();
  //     //   final sessions = await _account.listSessions();
  //     //   if (sessions.sessions.isNotEmpty) {
  //     //     _user = await _account.get();
  //     //     final session = await _account.getSession(sessionId: 'current');
  //     //     await _saveSessionId(session.$id);
  //     //   } else {
  //     //     await _createSession(credentials);
  //     //   }
  //     // } catch (err) {
  //     //   // ignore: avoid_print
  //     //   print(err);
  //     //   await _createSession(credentials);
  //     // }

  //     // if (needRegister) {
  //     //   await _createUserData(credentials.mail, registrationName!);
  //     // }
  //   }

  //   await _createUserData(credentials.mail, registrationName!);

  //   // try {
  //   //   print('try sessions');
  //   //   final sessions = await _account.listSessions();
  //   //   if (sessions.sessions.isNotEmpty) {
  //   //     print('sessions.isNotEmpty');
  //   //     _user = await _account.get();
  //   //     final session = await _account.getSession(sessionId: 'current');
  //   //     await _saveSessionId(session.$id);
  //   //   } else {
  //   //     print('sessions.isEmpty');
  //   //     try {
  //   //       final promise = await _account.createEmailPasswordSession(
  //   //         email: credentials.mail,
  //   //         password: credentials.password,
  //   //       );
  //   //       _user = await _account.get();
  //   //       await _saveSessionId(promise.$id);
  //   //     } catch (err) {
  //   //       // ignore: avoid_print
  //   //       print(err);
  //   //       // AppwriteException (AppwriteException: user_session_already_exists, Creation of a session is prohibited when a session is active. (401))
  //   //       rethrow;
  //   //     }
  //   //   }
  //   // } catch (err) {
  //   //   // ignore: avoid_print
  //   //   print(err);
  //   //   rethrow;
  //   // }

  //   await getUserData();
  //   _initMessaging();
  //   _startOnlineTimer();
  // }

  Future<void> _createSession(UserCredentials credentials) async {
    try {
      final promise = await _account.createEmailPasswordSession(
        email: credentials.mail,
        password: credentials.password,
      );
      _user = await _account.get();
      await _saveSessionId(promise.$id);
    } catch (err) {
      // ignore: avoid_print
      print(err);
      rethrow;
    }
  }

  Future _saveSessionId(String newSessionId) async {
    sessionID = newSessionId;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(sessionIdKey, sessionID!);
  }

  Future _createUserData({
    required String email,
    required String name,
    required String phone,
  }) async {
    // final phone = email.split('@')[0];

    await _databaseService.users.createUser(
      name: name,
      uid: userId,
      phone: phone,
    );
  }
}
