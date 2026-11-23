import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('SlopeNet FCM background message: ${message.messageId}');
}

class NotificationServicesController extends GetxController {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _alertChannel =
  AndroidNotificationChannel(
    'slopenet_alerts_channel',
    'SlopeNet Route & Hazard Alerts',
    description: 'Real-time landslide warnings and route updates',
    importance: Importance.high,
  );

  final RxnString fcmToken = RxnString();
  final RxBool isInitialized = false.obs;

  Future<NotificationServicesController> init() async {
    if (isInitialized.value) return this;

    await _requestPermissionAndInitLocal();
    await _setupChannels();
    await _syncToken();
    _listenToMessages();

    isInitialized.value = true;
    return this;
  }

  Future<void> _requestPermissionAndInitLocal() async {
    try {
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidInit);

      await _localNotifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          final rawPayload = response.payload;
          if (rawPayload != null && rawPayload.isNotEmpty) {
            try {
              final data = jsonDecode(rawPayload) as Map<String, dynamic>;
              _handleNotificationTap(data);
            } catch (e) {
              debugPrint('Error decoding notification payload: $e');
            }
          }
        },
      );
    } catch (e) {
      debugPrint('Error initializing notification permissions/plugin: $e');
    }
  }

  Future<void> _setupChannels() async {
    try {
      final androidPlugin =
      _localNotifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(_alertChannel);
    } catch (e) {
      debugPrint('Error creating Android notification channel: $e');
    }
  }

  Future<void> _syncToken() async {
    try {
      final token = await _messaging.getToken();
      fcmToken.value = token;

      debugPrint('==================================================');
      debugPrint('SlopeNet FCM Token: $token');
      debugPrint('==================================================');

      if (token != null) {
        await saveTokenToUserDoc(token);
      }

      await _messaging.subscribeToTopic('all_travelers');

      _messaging.onTokenRefresh.listen((newToken) async {
        fcmToken.value = newToken;
        debugPrint('SlopeNet Refreshed FCM Token: $newToken');
        await saveTokenToUserDoc(newToken);
      });
    } catch (e) {
      debugPrint('Error syncing FCM token: $e');
    }
  }

  /// Call this after login/signup so the token is saved to `users/{uid}`
  /// if the user was signed out when `init()` ran at startup.
  Future<void> saveTokenToUserDoc([String? explicitToken]) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final token = explicitToken ?? fcmToken.value ?? await _messaging.getToken();
    if (uid == null || token == null || token.isEmpty) return;

    fcmToken.value = token;

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'fcmToken': token,
        'fcmUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving FCM token to Firestore: $e');
    }
  }

  void _listenToMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ??
          message.data['title']?.toString() ??
          'SlopeNet Alert';
      final body = message.notification?.body ??
          message.data['body']?.toString() ??
          '';

      if (title.isNotEmpty || body.isNotEmpty) {
        _showForegroundNotification(
          title: title,
          body: body,
          payload: jsonEncode(message.data),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message.data);
    });
  }

  Future<void> handleInitialTerminatedMessage() async {
    try {
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage.data);
      }
    } catch (e) {
      debugPrint('Error reading initial terminated FCM message: $e');
    }
  }

  Future<void> _showForegroundNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _alertChannel.id,
        _alertChannel.name,
        channelDescription: _alertChannel.description,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
    );

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    final route = data['route']?.toString();
    if (route != null && route.isNotEmpty) {
      Get.toNamed(route, arguments: data);
    }
  }
}