import 'package:practical_social_media/service/firebase_service.dart';

class UserService {
  UserService._internal();

  static final UserService _instance = UserService._internal();

  static UserService get instance => _instance;
  bool hasLoggedIn = false;

  Future retrieveLoggedInUserDetail() async {
    try {
      final FirebaseService firebaseService = FirebaseService();
      var users = firebaseService.currentUser;
      if (users != null) {
        hasLoggedIn = true;
      } else {
        hasLoggedIn = false;
      }
    } catch (e) {
      hasLoggedIn = false;
    }
  }
}
