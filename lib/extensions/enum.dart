// lib/enums/post_filter_type.dart
enum PostFilterType {
  all,
  myPosts,
}

extension PostFilterTypeExtension on PostFilterType {
  String get title {
    switch (this) {
      case PostFilterType.all:
        return 'All Posts';
      case PostFilterType.myPosts:
        return 'My Posts';
    }
  }

  static PostFilterType fromTitle(String title) {
    switch (title) {
      case 'My Posts':
        return PostFilterType.myPosts;
      default:
        return PostFilterType.all;
    }
  }
}
