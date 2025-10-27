import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practical_social_media/cubit/posts/posts_state.dart';
import 'package:practical_social_media/extensions/enum.dart';
import 'package:practical_social_media/model/post_model.dart';
import 'package:practical_social_media/model/user_model.dart';
import 'package:practical_social_media/repository/post_repository.dart';

class PostsCubit extends Cubit<PostsState> {
  final PostRepository postRepository;

  PostsCubit({required this.postRepository}) : super(PostsInitialState());
  UserModel? userModel;
  List<PostModel> _postData = [];
  List<PostModel> filteredPosts = [];
  PostFilterType currentFilter = PostFilterType.all;
  DocumentSnapshot? lastDoc;

  /// 📝 Add a new post
  void fetchCurrentUser() async {
    try {
      final userData = await postRepository.getCurrentUser();
      if (userData != null) {
        userModel = userData;
        emit(GetCurrentUserSuccessState());
      } else {
        emit(PostsErrorState("User data not found"));
      }
    } catch (e) {
      emit(PostsErrorState(e.toString()));
    }
  }

  /// 📝 Add a new post
  void addPost({required PostModel post}) async {
    lastDoc = null;

    try {
      emit(PostsLoadingState());
      await postRepository.addPost(post: post);

      emit(PostsSuccessState());
    } catch (e) {
      emit(PostsErrorState(e.toString()));
    }
  }

  void configureListener() {
    postRepository.postStream().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final newPost = PostModel.fromJson(change.doc.data()!);
          filteredPosts.insert(0, newPost); // Add only new items
        }
      }
    });
  }

  /// Fetch posts in real-time and store them in local postData list
  void fetchPosts({bool showLoader = false}) async {
    if (showLoader) {
      emit(PostsLoadingState());
    }

    String? userId;

    if (currentFilter == PostFilterType.myPosts) {
      userId = userModel?.uid;
    }

    var response = await postRepository.getPosts(
      userId: userId,
      lastDoc: lastDoc,
    );
    if (lastDoc == null) {
      filteredPosts.clear();
    }

    var oldData = filteredPosts;

    var newData = response.posts;

    if (newData.isNotEmpty) {
      lastDoc = response.lastDoc;
    }
    filteredPosts = oldData + newData;

    emit(FetchPostSuccessState());
  }

  /// Fetch posts in real-time and store them in local postData list
  void logout() async {
    emit(PostsLoadingState());
    try {
      await postRepository.logout();
      emit(LogoutSuccessState());
    } catch (e) {
      emit(PostsErrorState(e.toString()));
    }
  }

  void applyFilter(PostFilterType filter) {
    currentFilter = filter;
    lastDoc = null;
    fetchPosts();
  }

  /// Filter posts
  // void applyFilter(PostFilterType filter, {String? currentUserId}) {
  //   currentFilter = filter;
  //   List<PostModel> tempList = [];
  //
  //   switch (filter) {
  //     case PostFilterType.myPosts:
  //       tempList =
  //           _postData.where((post) => post.userId == currentUserId).toList();
  //       break;
  //
  //     case PostFilterType.today:
  //       final now = DateTime.now();
  //       tempList =
  //           _postData.where((post) {
  //             final created = post.createdAt ?? DateTime(2000);
  //             return created.year == now.year &&
  //                 created.month == now.month &&
  //                 created.day == now.day;
  //           }).toList();
  //       break;
  //
  //     case PostFilterType.all:
  //       tempList = _postData;
  //   }
  //   filteredPosts = tempList;
  //   emit(FetchPostSuccessState());
  // }
}
