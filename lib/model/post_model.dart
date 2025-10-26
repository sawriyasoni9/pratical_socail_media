import 'package:cloud_firestore/cloud_firestore.dart';

class PostModelData {
  List<PostModel> posts = [];
  DocumentSnapshot? lastDoc;

  PostModelData({this.posts = const [], this.lastDoc});
}

class PostModel {
  String? userId;
  String? postId;
  String? userName;
  String? message;
  DateTime? createdAt;

  PostModel({
    this.userId = '',
    this.postId = '',
    this.userName = '',
    this.message = '',
    this.createdAt,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    postId = json['postId'];
    userName = json['userName'];
    message = json['message'];
    createdAt = DateTime.parse(json['createdAt']);
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'postId': createdAt?.millisecondsSinceEpoch.toString(),
      'userName': userName,
      'message': message,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
