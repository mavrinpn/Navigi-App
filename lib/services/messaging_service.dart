import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:smart/services/database/database_service.dart';

class MessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? userId;
  final DatabaseService _databaseService;
  StreamSubscription? _subscription;

  MessagingService({required DatabaseService databaseService})
      : _databaseService = databaseService;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();

    print('fcm token: $fCMToken');
    await saveTokenToDatabase(fCMToken);

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
  }


  Future _onForegroundMessage(RemoteMessage message) async {
    print('got message in foreground');
    print('data: ${message.data}');

    if (message.notification != null) {
      print('message notification: ${message.notification}');
    }
  }


  static Future onBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();

    print('got message in background');
    print('data: ${message.data}');

    if (message.notification != null) {
      print('message notification: ${message.notification}');
    }
  }


  Future<void> saveTokenToDatabase(String? token) async {
    if (userId != null && token != null) {
      _databaseService.notifications.refreshNotificationToken(userId!, token);
    }
  }

  void handleTokenRefreshing() {
    _subscription?.cancel();

    if (userId != null) {
      _subscription = _firebaseMessaging.onTokenRefresh.listen((event) {
        saveTokenToDatabase(event);
      });
    }
  }

  void close() => _subscription?.cancel();
}
