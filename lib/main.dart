import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:practical_social_media/service/push_notification_service.dart';
import 'package:practical_social_media/service/user_service.dart' show UserService;
import 'package:practical_social_media/ui/app.dart';

/// ✅ Step 1: Define the background message handler **at the top-level**
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🌀 onBackgroundMessage: ${message.messageId}');
  print('📩 Message data: ${message.data}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// ✅ Step 2: Register the background handler before initializing Firebase
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// ✅ Step 3: Initialize Firebase
  await Firebase.initializeApp();

  /// ✅ Step 4: Initialize your Notification service
  await NotificationService.init();

  /// To retrieve the login detail from local DB
  await UserService.instance.retrieveLoggedInUserDetail();

  /// ✅ Step 5: Run your App
  runApp(const App());
}

