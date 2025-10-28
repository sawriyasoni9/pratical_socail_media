import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:practical_social_media/cubit/posts/posts_cubit.dart';
import 'package:practical_social_media/cubit/posts/posts_state.dart';
import 'package:practical_social_media/extensions/app_loader.dart';
import 'package:practical_social_media/extensions/message_constant.dart';
import 'package:practical_social_media/model/post_model.dart';
import 'package:practical_social_media/model/user_model.dart';
import 'package:practical_social_media/routes/app_routes.dart';
import 'package:practical_social_media/ui/common/custom_text_field.dart';
import 'package:practical_social_media/ui/common/filter_sheet.dart';
import 'package:practical_social_media/ui/posts_module/post_tile.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PostsScreen extends StatefulWidget {
  final PostsCubit postsCubit;

  const PostsScreen({super.key, required this.postsCubit});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final TextEditingController _postController = TextEditingController();
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  UserModel? get _currentUserModel {
    return widget.postsCubit.userModel;
  }

  @override
  void initState() {
    super.initState();
    widget.postsCubit.fetchCurrentUser();
    widget.postsCubit.configureListener();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      widget.postsCubit.fetchPosts(showLoader: true);
    });
  }

  void _addPost() {
    if (_postController.text.isEmpty) {
      Fluttertoast.showToast(msg: MessageConstant.postMessageEmpty);
    } else {
      widget.postsCubit.addPost(
        post: PostModel(
          userId: _currentUserModel?.uid ?? '',
          userName:
              '${_currentUserModel?.firstName} ${_currentUserModel?.lastName}',
          message: _postController.text.trim(),
          createdAt: DateTime.now(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsCubit, PostsState>(
      bloc: widget.postsCubit,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            title: Text(
              '${MessageConstant.hey}, ${_currentUserModel?.firstName} ${_currentUserModel?.lastName} 👋',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.filter_alt_rounded,
                  color: Colors.black54,
                ),
                onPressed: () {
                  Get.bottomSheet(
                    FilterBottomSheet(
                      postsCubit: widget.postsCubit,
                      currentUserModel: _currentUserModel,
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.black54),
                onPressed: () {
                  widget.postsCubit.logout();
                },
              ),
            ],
          ),
          body: _mainBody(),
        );
      },
    );
  }

  Widget _mainBody() {
    return Column(
      children: [
        _buildPostInput(),
        const Divider(height: 1),
        Expanded(child: _listView()),
      ],
    );
  }

  Widget _listView() {
    return BlocConsumer<PostsCubit, PostsState>(
      bloc: widget.postsCubit,
      listener: (context, state) {
        _refreshController.refreshCompleted();
        _refreshController.loadComplete();

        if (state is PostsLoadingState) {
          AppLoader.showLoader(context);
        } else {
          AppLoader.hideLoader();
          if (state is LogoutSuccessState) {
            Fluttertoast.showToast(msg: MessageConstant.logoutSuccess);
            Get.offAllNamed(AppRoutes.loginScreen);
          }
          if (state is PostsSuccessState) {
            _postController.clear();
          }
          if (state is PostsErrorState) {
            Fluttertoast.showToast(msg: 'Error: ${state.errorMessage}');
          }
        }
      },
      builder: (context, state) {
        final posts = widget.postsCubit.filteredPosts;

        if (posts.isEmpty) {
          return Center(
            child:
                state is PostsLoadingState
                    ? const SizedBox.shrink()
                    : const Text(
                      MessageConstant.noPostAvailable,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
          );
        }

        return SmartRefresher(
          controller: _refreshController,
          onLoading: _onLoading,
          enablePullUp: true,
          enablePullDown: true,
          onRefresh: _onRefresh,
          physics: const BouncingScrollPhysics(),

          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostTile(post: post);
            },
          ),
        );
      },
    );
  }

  Widget _buildPostInput() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  isMultiline: true,
                  controller: _postController,
                  hintText: MessageConstant.postMessageHint,
                  keyboardType: TextInputType.text,
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _addPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  MessageConstant.post,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onLoading() async {
    widget.postsCubit.fetchPosts();
  }

  void _onRefresh() async {
    widget.postsCubit.lastDoc = null;
    widget.postsCubit.fetchPosts();
  }
}
