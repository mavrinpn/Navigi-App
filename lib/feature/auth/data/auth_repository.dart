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

  User? loggedUser;
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

  String get userId => loggedUser?.$id ?? '';

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

  // BehaviorSubject<EntranceStateEnum> authState = BehaviorSubject<EntranceStateEnum>.seeded(EntranceStateEnum.wait);

  BehaviorSubject<AuthStateEnum> appState = BehaviorSubject<AuthStateEnum>.seeded(AuthStateEnum.wait);

  BehaviorSubject<LoadingStateEnum> profileState = BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.loading);

  Future<void> _initMessaging() async {
    _messagingService.userId = loggedUser?.$id ?? '';
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
        loggedUser = await _account.get();
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
        uid: loggedUser?.$id ?? '',
        name: name,
        phone: phone,
        imageUrl: imageUrl,
      );

      // await _account.updatePhone(
      //   phone: '+213$phone',
      //   password: password,
      // );
    } catch (e) {
      profileState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }

  Future<void> deleteProfile() async {
    try {
      await _databaseService.users.deleteProfile(
        uid: loggedUser?.$id ?? '',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _account.deleteSessions();
      sessionID = null;
      loggedUser = null;
      userData = null;
    } catch (e) {
      log('session already deleted');
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    // authState.add(EntranceStateEnum.wait);
    _messagingService.userId = null;
    appState.add(AuthStateEnum.unAuth);
  }

  Future<void> deleteIdentity() async {
    if (loggedUser != null) {
      try {
        await _account.deleteIdentity(identityId: loggedUser!.$id);
        sessionID = null;
        loggedUser = null;
        userData = null;
      } catch (e) {
        log(e.toString());
      }
    } else {
      log('loggedUser is null');
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _messagingService.userId = null;
    appState.add(AuthStateEnum.unAuth);
  }

  Future<String?> login(String email, String password) async {
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
        uid: loggedUser!.$id,
        email: credentials.mail,
        name: '',
        phone: '',
      );

      if (loggedUser!.emailVerification) {
        await getUserData();
        _initMessaging();
        _startOnlineTimer();

        // authState.add(EntranceStateEnum.success);
        appState.add(AuthStateEnum.auth);
      } else {
        return 'user-not-verificated';
      }
    } catch (err) {
      // ignore: avoid_print
      print(err);
      return err.toString();
      // authState.add(EntranceStateEnum.fail);
    }
    return null;
  }

  // Future<void> createAccountAndSendSms({
  //   required String phone,
  //   required bool isPasswordRestore,
  // }) async {
  //   await _createTempAccount(phone);
  //   await _databaseService.users.sendSms();
  // }

  Future<String?> createEmailAccount({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      await _account.deleteSessions();
    } catch (err) {
      // ignore: avoid_print
      print('deleteSessions: $err');
    }

    final accountName = email.split('@').firstOrNull ?? 'Guest';
    final uid = ID.unique();

    try {
      await _account.create(
        userId: uid,
        email: email,
        password: password,
        name: accountName,
      );
    } catch (err) {
      // ignore: avoid_print
      print('account.create $err');
      return err.toString();
    }

    try {
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      await _account.updatePhone(
        phone: '+213$phone',
        password: password,
      );
      loggedUser = await _account.get();
    } catch (err) {
      // ignore: avoid_print
      print('createEmailPasswordSession $err');
      return err.toString();
    }

    final account = await _account.get();
    try {
      await _createUserData(
        uid: account.$id,
        email: email,
        name: name,
        phone: phone,
      );
    } catch (err) {
      // ignore: avoid_print
      print('createUserData $err');
      return err.toString();
    }

    return null;
  }

  Future<void> sendEmailCode({
    required String email,
    required String password,
  }) async {
    await _databaseService.users.sendEmailCode(email);
  }

  Future<String?> confirmEmailCode(
    String code, {
    required String password,
    required String name,
    required String phone,
    required String email,
  }) async {
    // authState.add(EntranceStateEnum.loading);

    final status = await _databaseService.users.confirmEmailCode(
      code: code,
      email: email,
    );

    if (status == 'ok') {
      await getUserData();
      _initMessaging();
      _startOnlineTimer();

      // authState.add(EntranceStateEnum.success);
      appState.add(AuthStateEnum.auth);
    } else {
      return status;
    }
    return null;
  }

  Future<String?> updateEmailCode(
    String code, {
    required String password,
    required String email,
  }) async {
    final status = await _databaseService.users.updatePassword(
      code: code,
      email: email,
      password: password,
    );

    if (status == 'ok') {
    } else {
      return status;
    }
    return null;
  }

  Future<bool> getUserData() async {
    profileState.add(LoadingStateEnum.loading);
    try {
      final res = await _databaseService.users.getUserData(uid: loggedUser?.$id ?? '');
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

  // Future _createTempAccount(String email) async {
  //   const String password = 'temppassword123';
  //   //final String? email = await _getEmailByPhone(phone);
  //   try {
  //     await _account.deleteSessions();
  //   } catch (err) {
  //     // ignore: avoid_print
  //     print(err);
  //   }

  //   try {
  //     await _account.create(
  //       userId: ID.unique(),
  //       email: email,
  //       password: password,
  //       name: 'Guest',
  //     );
  //   } catch (err) {
  //     // ignore: avoid_print
  //     print(err);
  //   }

  //   try {
  //     await _account.createEmailPasswordSession(
  //       email: email,
  //       password: password,
  //     );
  //   } catch (err) {
  //     // ignore: avoid_print
  //     print(err);
  //   }
  // }

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
      loggedUser = await _account.get();
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
    required String uid,
    required String email,
    required String name,
    required String phone,
  }) async {
    // final phone = email.split('@')[0];

    await _databaseService.users.createUser(
      uid: uid,
      name: name,
      phone: phone,
    );
  }
}
