import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practical_social_media/cubit/auth_cubit/auth_state.dart';
import 'package:practical_social_media/extensions/message_constant.dart';
import 'package:practical_social_media/extensions/string_extension.dart';
import 'package:practical_social_media/model/user_model.dart';
import 'package:practical_social_media/repository/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(AuthInitialState());

  void submitLogin({required String email, required String password}) {
    if (email.isEmpty) {
      emit(AuthErrorState(message: MessageConstant.emptyEmail));
    } else if (!email.hasValidEmail) {
      emit(AuthErrorState(message: MessageConstant.validEmail));
    } else if (password.isEmpty) {
      emit(AuthErrorState(message: MessageConstant.emptyPassword));
    } else {
      login(email, password);
    }
  }

  void login(String email, String password) async {
    emit(AuthLoadingState());
    try {
      bool success = await authRepository.login(email, password);
      if (success) {
        emit(AuthSuccessState());
      } else {
        emit(AuthErrorState(message: MessageConstant.loginError));
      }
    } on FormatException catch (e) {
      emit(AuthErrorState(message: e.message));
    }
  }

  void submitSign({required UserModel param}) {
    if (param.firstName?.isEmpty ?? true) {
      emit(AuthErrorState(message: MessageConstant.emptyFirstName));
    } else if (param.lastName?.isEmpty ?? true) {
      emit(AuthErrorState(message: MessageConstant.emptyLastName));
    } else if (param.email?.isEmpty ?? true) {
      emit(AuthErrorState(message: MessageConstant.emptyEmail));
    } else if (param.email?.hasValidEmail == false) {
      emit(AuthErrorState(message: MessageConstant.validEmail));
    } else if (param.password?.isEmpty ?? true) {
      emit(AuthErrorState(message: MessageConstant.emptyPassword));
    } else {
      signUp(param: param);
    }
  }

  void signUp({required UserModel param}) async {
    emit(AuthLoadingState());
    try {
      bool success = await authRepository.signUp(param: param);
      if (success) {
        emit(AuthSuccessState());
      } else {
        emit(AuthErrorState(message: MessageConstant.signUpField));
      }
    } on FormatException catch (e) {
      emit(AuthErrorState(message: e.message));
    }
  }
}
