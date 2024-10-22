import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/enum/enum.dart';
import 'package:smart/models/user.dart';
import 'package:smart/services/database/database_service.dart';
import 'package:smart/services/messaging_service.dart';
import 'package:smart/services/storage_service.dart';

class AuthRepository {
  final Client client;
  final Account _account;
  final Functions _functions;
  final DatabaseService _databaseService;
  final MessagingService _messagingService;
  final FileStorageManager _fileStorageManager;

  final deleteAccountFunc = '666c00bba70155719253';
  final deleteUserDataFunc = '669e74e0e58a01240ecf';

  User? loggedUser;
  UserData? userData;
  String? sessionID;

  String get userId => loggedUser?.$id ?? '';

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

  AuthRepository({
    required this.client,
    required DatabaseService databaseService,
    required MessagingService messagingService,
    required FileStorageManager fileStorageManager,
    required Functions functions,
  })  : _account = Account(client),
        _functions = functions,
        _fileStorageManager = fileStorageManager,
        _messagingService = messagingService,
        _databaseService = databaseService {
    checkLogin();
  }

  BehaviorSubject<AuthStateEnum> appState = BehaviorSubject<AuthStateEnum>.seeded(AuthStateEnum.wait);
  BehaviorSubject<LoadingStateEnum> profileState = BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.loading);

  Future<void> _initialize() async {
    await getUserData();
    initNotification();
    _startOnlineTimer();
  }

  void initNotification() {
    _messagingService.initNotification(loggedUser?.$id ?? '');
  }

  Future<String?> checkLogin() async {
    try {
      final session = await _account.getSession(sessionId: 'current');
      debugPrint('checkLogin session ${session.$id}');
      sessionID = session.$id;

      try {
        final account = await _account.get();
        loggedUser = account;

        final userData = await _databaseService.users.getUserData(uid: account.$id);
        if (userData != null && userData.name.isNotEmpty && userData.phone.isNotEmpty) {
          await _initialize();
          appState.add(AuthStateEnum.auth);
          return null;
        } else {
          appState.add(AuthStateEnum.authWithNoData);
          return null;
        }
      } catch (err) {
        debugPrint('account.get ${err.toString()}');
        appState.add(AuthStateEnum.unAuth);
        return 'account.get ${err.toString()}';
      }
    } catch (err) {
      debugPrint('getSession ${err.toString()}');
      appState.add(AuthStateEnum.unAuth);
      return 'getSession ${err.toString()}';
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
    _messagingService.userId = null;
    appState.add(AuthStateEnum.unAuth);
  }

  Future<String> getJwt() => _account.createJWT().then((value) => value.jwt);

  Future<void> deleteIdentity() async {
    if (loggedUser != null) {
      final jwt = await getJwt();
      final encodedBody = jsonEncode({
        'jwt': jwt,
      });

      try {
        final res = await _functions.createExecution(
          functionId: deleteAccountFunc,
          body: encodedBody,
        );

        debugPrint('${res.responseStatusCode}');

        sessionID = null;
        loggedUser = null;
        userData = null;
      } catch (e) {
        log(e.toString());
      }

      try {
        final res = await _functions.createExecution(
          functionId: deleteUserDataFunc,
          body: encodedBody,
        );

        debugPrint('${res.responseStatusCode}');

        sessionID = null;
        loggedUser = null;
        userData = null;
      } catch (e) {
        log(e.toString());
      }
    } else {
      log('loggedUser is null');
    }

    logout();
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
        debugPrint(err.toString());
      }

      try {
        await _account.createEmailPasswordSession(
          email: credentials.mail,
          password: credentials.password,
        );
        loggedUser = await _account.get();
      } catch (err) {
        debugPrint(err.toString());
        return err.toString();
      }

      final userData = await _databaseService.users.getUserData(uid: loggedUser!.$id);
      if (userData != null && userData.name.isNotEmpty && userData.phone.isNotEmpty) {
        if (loggedUser!.emailVerification) {
          await _initialize();
          appState.add(AuthStateEnum.auth);
        } else {
          return 'user-not-verificated';
        }
      } else {
        appState.add(AuthStateEnum.authWithNoData);
        return null;
      }
    } catch (err) {
      debugPrint(err.toString());
      return err.toString();
    }
    return null;
  }

  Future<String?> createEmailAccount({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      await _account.deleteSessions();
    } catch (err) {
      debugPrint('deleteSessions: $err');
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
      debugPrint('account.create $err');
      return err.toString();
    }

    try {
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      loggedUser = await _account.get();
    } catch (err) {
      debugPrint('createEmailPasswordSession $err');
      return err.toString();
    }

    final account = await _account.get();
    try {
      await _databaseService.users.createUser(
        uid: account.$id,
        name: name,
        phone: phone,
      );
    } catch (err) {
      debugPrint('createUserData $err');
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
    final status = await _databaseService.users.confirmEmailCode(
      code: code,
      email: email,
    );

    if (status == 'ok') {
      await _initialize();
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

  Future<UserData?> getUserDataById(String id) async {
    try {
      final res = await _databaseService.users.getUserData(uid: id);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> signInWithApple() async {
    debugPrint('signInWithApple');
    try {
      await _account.deleteSessions();
    } catch (err) {
      debugPrint('deleteSessions: $err');
    }

    try {
      await _account.createOAuth2Session(
        provider: OAuthProvider.apple,
      );
    } catch (err) {
      debugPrint('account.signInWithApple $err');
      return err.toString();
    }

    return checkLogin();
  }

  Future<String?> signInWithGoogle() async {
    debugPrint('signInWithGoogle');
    try {
      await _account.deleteSessions();
    } catch (err) {
      debugPrint('deleteSessions: $err');
    }

    try {
      await _account.createOAuth2Session(provider: OAuthProvider.google, scopes: [
        'https://www.googleapis.com/auth/userinfo.email',
        'https://www.googleapis.com/auth/userinfo.profile',
      ]);
    } catch (err) {
      debugPrint('account.signInWithGoogle $err');
      return err.toString();
    }

    return checkLogin();
  }

  Future<void> setUserData({
    required String name,
    required String phone,
  }) async {
    if (loggedUser != null) {
      try {
        await _databaseService.users.createUser(
          uid: loggedUser!.$id,
          name: name,
          phone: phone,
        );
        checkLogin();
      } catch (err) {
        debugPrint('createUserData $err');
      }
    } else {
      debugPrint('setUserData loggedUser is null');
    }
  }
}
