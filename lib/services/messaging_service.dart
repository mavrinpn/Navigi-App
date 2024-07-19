import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/feature/settings/ui/notifications_screen.dart';
import 'package:smart/services/database/database_service.dart';

final StreamController<String> selectNotificationStream = StreamController<String>.broadcast();

class MessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? userId;
  final DatabaseService _databaseService;
  StreamSubscription? _subscription;

  MessagingService({required DatabaseService databaseService}) : _databaseService = databaseService;

  Future<void> initNotification(String userId) async {
    this.userId = userId;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isNotificationsEnabled = prefs.getBool(notificationsCommonKey) ?? true;
    debugPrint('isNotificationsEnabled = $isNotificationsEnabled');
    if (isNotificationsEnabled) {
      await _firebaseMessaging.requestPermission();
      final fCMToken = await _firebaseMessaging.getToken();

      await saveTokenToDatabase(fCMToken);

      FirebaseMessaging.onMessage.listen(_onForegroundMessage);

      _handleTokenRefreshing();
    } else {
      await FirebaseMessaging.instance.deleteToken();
      await removeTokenFromDatabase();
    }
  }

  Future _onForegroundMessage(RemoteMessage message) async {
    if (message.notification != null && message.data['room_id'] != null) {
      //selectNotificationStream.add(message.data['room_id']);
    }
  }

  static Future onBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();

    if (message.notification != null && message.data['room_id'] != null) {
      selectNotificationStream.add(message.data['room_id']);
    }
  }

  static void checkInitialMessage() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();

    if (message != null && message.notification != null && message.data['room_id'] != null) {
      selectNotificationStream.add(message.data['room_id']);
    }
  }

  // void deteleToken() async {
  //   await FirebaseMessaging.instance.deleteToken();
  //   await removeTokenFromDatabase();
  // }

  Future<void> saveTokenToDatabase(String? token) async {
    if (userId != null && token != null) {
      final tokenExists = await _databaseService.notifications.userExists(userId!);

      final userExists = await _databaseService.users.userExists(userId!);
      if (!userExists) {
        await _databaseService.users.createUser(
          name: '',
          uid: userId!,
          phone: '',
        );
      }

      if (tokenExists) {
        await _databaseService.notifications.updateNotificationToken(userId!, token);
      } else {
        await _databaseService.notifications.createNotificationToken(userId!, token);
      }
    }
  }

  Future<void> removeTokenFromDatabase() async {
    if (userId != null) {
      debugPrint('removeTokenFromDatabase $userId');
      final tokenExists = await _databaseService.notifications.userExists(userId!);

      final userExists = await _databaseService.users.userExists(userId!);
      if (userExists && tokenExists) {
        await _databaseService.notifications.updateNotificationToken(userId!, '');
      }
    }
  }

  void _handleTokenRefreshing() {
    _subscription?.cancel();

    if (userId != null) {
      _subscription = _firebaseMessaging.onTokenRefresh.listen((event) {
        saveTokenToDatabase(event);
      });
    }
  }

  void close() => _subscription?.cancel();
}
