import 'package:firebase_auth/firebase_auth.dart';
import 'package:practical_social_media/model/user_model.dart';
import 'package:practical_social_media/service/firebase_service.dart';

class AuthRepository {
  final FirebaseService _firebaseService = FirebaseService();

  /// ✅ Sign Up user
  Future<bool> signUp({required UserModel param}) async {
    try {
      final user = await _firebaseService.createAuthUser(
        param.email ?? '',
        param.password ?? '',
      );
      if (user == null) {
        return false;
      }

      await _firebaseService.saveUserData(user, param);
      return true;
    } on FirebaseAuthException catch (e) {
      throw FormatException(_handleFirebaseError(e));
    } catch (e) {
      throw FormatException(e.toString());
    }
  }

  /// ✅ Login user
  Future<bool> login(String email, String password) async {
    try {
      final user = await _firebaseService.loginUser(email, password);
      return user != null;
    } on FirebaseAuthException catch (e) {
      throw FormatException(_handleFirebaseError(e));
    }
  }

  String _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return "Email already in use.";
      case 'invalid-email':
        return 'Invalid email format.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      default:
        return 'Auth error: ${e.message}';
    }
  }
}
