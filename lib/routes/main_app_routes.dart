import 'package:get/get.dart';
import 'package:practical_social_media/cubit/auth_cubit/auth_cubit.dart';
import 'package:practical_social_media/cubit/posts/posts_cubit.dart';
import 'package:practical_social_media/repository/auth_repository.dart';
import 'package:practical_social_media/repository/post_repository.dart';
import 'package:practical_social_media/routes/app_routes.dart';
import 'package:practical_social_media/ui/lrf_module/login_screen.dart';
import 'package:practical_social_media/ui/lrf_module/sign_up_screen.dart';
import 'package:practical_social_media/ui/posts_module/posts_screen.dart';

class MainAppRoutes {
  static var routes = [
    GetPage(
      name: AppRoutes.loginScreen,
      page:
          () => LoginScreen(
            authCubit: AuthCubit(authRepository: AuthRepository()),
          ),
    ),
    GetPage(
      name: AppRoutes.signUpScreen,
      page:
          () => SignUpScreen(
            authCubit: AuthCubit(authRepository: AuthRepository()),
          ),
    ),
    GetPage(
      name: AppRoutes.postsScreen,
      page:
          () => PostsScreen(
            postsCubit: PostsCubit(postRepository: PostRepository()),
          ),
    ),
  ];
}
