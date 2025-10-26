import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:practical_social_media/cubit/auth_cubit/auth_cubit.dart';
import 'package:practical_social_media/cubit/auth_cubit/auth_state.dart';
import 'package:practical_social_media/extensions/app_loader.dart';
import 'package:practical_social_media/extensions/message_constant.dart';
import 'package:practical_social_media/model/user_model.dart';
import 'package:practical_social_media/routes/app_routes.dart';
import 'package:practical_social_media/ui/common/custom_text_field.dart';
import 'package:practical_social_media/ui/common/primary_button.dart';

class SignUpScreen extends StatefulWidget {
  final AuthCubit authCubit;

  const SignUpScreen({super.key, required this.authCubit});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final ValueNotifier<bool> _hasPasswordSecure = ValueNotifier(true);

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _hasPasswordSecure.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: Get.height * 0.30,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF6D28D9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.person_add_alt_1, color: Colors.white, size: 80),
                    SizedBox(height: 8),
                    Text(
                      MessageConstant.createAccount,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _mainBody(),
          ],
        ),
      ),
    );
  }

  Widget _mainBody() {
    return BlocListener<AuthCubit, AuthState>(
      bloc: widget.authCubit,
      listener: (context, state) {
        if (state is AuthLoadingState) {
          AppLoader.showLoader(context);
        } else if (state is AuthSuccessState) {
          AppLoader.hideLoader();
          Fluttertoast.showToast(msg: MessageConstant.signUpSuccessMessage);
          Get.offAllNamed(AppRoutes.postsScreen);
        } else if (state is AuthErrorState) {
          AppLoader.hideLoader();
          Fluttertoast.showToast(msg: state.message);
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _firstNameController,
                          hintText: MessageConstant.firstName,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: CustomTextField(
                          controller: _lastNameController,
                          hintText: MessageConstant.lastName,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _emailController,
                    hintText: MessageConstant.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  ValueListenableBuilder(
                    valueListenable: _hasPasswordSecure,
                    builder: (context, value, child) {
                      return CustomTextField(
                        suffixIcon:
                            _hasPasswordSecure.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                        controller: _passwordController,
                        onSuffixTap: () {
                          _hasPasswordSecure.value = !_hasPasswordSecure.value;
                        },
                        hintText: MessageConstant.password,
                        obscureText: _hasPasswordSecure.value,
                      );
                    },
                  ),
                  const SizedBox(height: 30),

                  PrimaryButton(
                    title: MessageConstant.signUp,
                    onTap: () {
                      widget.authCubit.submitSign(
                        param: UserModel(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                MessageConstant.alreadyHaveAccount,
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  MessageConstant.login,
                  style: TextStyle(
                    color: Color(0xFF4F46E5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
