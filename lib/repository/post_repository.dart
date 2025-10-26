import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:practical_social_media/model/post_model.dart';
import 'package:practical_social_media/model/user_model.dart';
import 'package:practical_social_media/service/firebase_service.dart';

class PostRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<UserModel?> getCurrentUser() {
    return _firebaseService.getCurrentUserData();
  }

  Future<void> addPost({required PostModel post}) {
    return _firebaseService.storePost(post: post);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> postStream({String? userId, int limit = 10}) {
    return _firebaseService.getStream();
  }

  // Stream<PostModelData> getPosts({String? userId, int limit = 10, DocumentSnapshot? lastDoc,}) {
  //   return _firebaseService.fetchPosts(userId: userId, limit: limit, lastDoc: lastDoc);
  // }

  Future<PostModelData> getPosts({
    String? userId,
    int limit = 10,
    DocumentSnapshot? lastDoc,
  }) async {
    return await _firebaseService.fetchPosts(
      userId: userId,
      limit: limit,
      lastDoc: lastDoc,
    );
  }

  /// ✅ Logout user
  Future<void> logout() async => await _firebaseService.logoutUser();
}
