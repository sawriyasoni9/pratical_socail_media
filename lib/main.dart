import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:practical_social_media/service/user_service.dart';
import 'package:practical_social_media/ui/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Firebase
  await Firebase.initializeApp();

  /// To retrieve the login detail from local DB
  await UserService.instance.retrieveLoggedInUserDetail();

  /// Run your App
  runApp(const App());
}

