import 'package:flutter/material.dart';
import 'package:practical_social_media/routes/app_routes.dart';
import 'package:practical_social_media/routes/main_app_routes.dart';
import 'package:get/get.dart';
import 'package:practical_social_media/service/user_service.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      getPages: MainAppRoutes.routes,
      initialRoute: _initMainScreen,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }

  String get _initMainScreen {
    if (UserService.instance.hasLoggedIn) {
      return AppRoutes.postsScreen;
    }

    return AppRoutes.loginScreen;
  }
}
