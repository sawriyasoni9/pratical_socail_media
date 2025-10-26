import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practical_social_media/model/post_model.dart';
import 'package:practical_social_media/model/user_model.dart';


/// Firebase Service to handle Auth and Firestore operations
class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///  Create new Firebase Auth user
  Future<User?> createAuthUser(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    return credential.user;
  }

  ///  Save user info to Firestore
  Future<void> saveUserData(User user, UserModel param) async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(param.toJson(user.uid));
  }

  ///  Login user
  Future<User?> loginUser(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    return credential.user;
  }

  ///  Save user post in firebase
  Future<void> storePost({required PostModel post}) async {
    await _firestore.collection('posts').add(post.toJson());
  }

  ///  Logout user
  Future<void> logoutUser() async => await _auth.signOut();

  ///  Get currently logged-in user
  User? get currentUser => _auth.currentUser;

  ///  Get currently logged-in user
  Future<UserModel?> getCurrentUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return UserModel.fromJson(doc.data()!);
  }

  /// Fetch all posts from Firestore
  // Stream<List<PostModel>> getStream() {
  //   return _firestore
  //       .collection('posts')
  //       .orderBy('createdAt', descending: true)
  //       .snapshots()
  //       .map(
  //         (snapshot) =>
  //             snapshot.docs
  //                 .map((doc) => PostModel.fromJson(doc.data()))
  //                 .toList(),
  //       );
  // }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStream() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }


  // Stream<PostModelData> fetchPosts({
  //   String? userId,
  //   int limit = 10,
  //   DocumentSnapshot? lastDoc,
  // }) {
  //   Query query = _firestore.collection('posts');
  //
  //   if (userId != null) {
  //     query = query.where('userId', isEqualTo: userId);
  //   }
  //
  //   query = query.orderBy('createdAt', descending: true).limit(limit);
  //
  //   if (lastDoc != null) {
  //     query = query.startAfterDocument(lastDoc);
  //   }
  //
  //   return query.snapshots().map((snapshot) {
  //     var lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
  //     var posts =
  //         snapshot.docs
  //             .map(
  //               (doc) => PostModel.fromJson(doc.data() as Map<String, dynamic>),
  //             )
  //             .toList();
  //
  //     return PostModelData(lastDoc: lastDoc, posts: posts);
  //   });
  // }

  Future<PostModelData> fetchPosts({
    String? userId,
    int limit = 10,
    DocumentSnapshot? lastDoc,
  }) async {
    Query query = _firestore.collection('posts');

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    query = query.orderBy('createdAt', descending: true).limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final snapshot = await query.get();
    var posts =
        snapshot.docs
            .map(
              (doc) => PostModel.fromJson(doc.data() as Map<String, dynamic>),
            )
            .toList();

    var newDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
    return PostModelData(lastDoc: newDoc, posts: posts);
  }
}
