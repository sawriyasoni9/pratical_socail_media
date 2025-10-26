import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  // Initialize Notification System
  static Future<void> init() async {
    ///  Request permission
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    /// Initialize local notification plugin (for foreground messages)
    const AndroidInitializationSettings androidInitSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
    InitializationSettings(android: androidInitSettings);
    await _localNotifications.initialize(initSettings);

    /// Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message in foreground: ${message.notification?.title}');
      _showNotification(message);
    });

    /// Background tap handler (when user taps notification)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked: ${message.notification?.title}');
    });

    /// Get FCM Token (optional)
    final token = await _messaging.getToken();
    print(' FCM Token: $token');
    // subscribe to topic
    await _messaging.subscribeToTopic('allUsers');
    print('✅ Subscribed to topic: allUsers');
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel',
      'General Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails generalNotificationDetails =
    NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      0,
      message.notification?.title ?? 'New Message',
      message.notification?.body ?? '',
      generalNotificationDetails,
    );
  }
}
