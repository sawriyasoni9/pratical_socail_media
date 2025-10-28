abstract class PostsState {}

final class PostsInitialState extends PostsState {}

final class PostsLoadingState extends PostsState {}

final class GetCurrentUserSuccessState extends PostsState {}

final class PostsSuccessState extends PostsState {}

final class LogoutSuccessState extends PostsState {}

final class FetchPostSuccessState extends PostsState {}

final class PostsErrorState extends PostsState {
  final String errorMessage;

  PostsErrorState(this.errorMessage);
}
