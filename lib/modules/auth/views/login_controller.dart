library login_library;

import 'dart:convert';

import 'package:fizsell/core/config/AppConstants.dart';
import 'package:fizsell/modules/auth/models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/config/config.dart';
import '../../../../core/local/hive_constants.dart';
import 'package:flutter/material.dart';

import '../../../core/routes.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/base_widget.dart';
import '../bloc/auth_bloc.dart';

part 'login.dart';

class LoginController extends StatefulWidget {
  const LoginController({super.key});

  @override
  State<LoginController> createState() => LoginControllerState();
}

class LoginControllerState extends State<LoginController> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  String appVersion = "";

  bool isPasswordHidden = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = info.version;
    });
  }

  void changePasswordHidden() {
    setState(() {
      if (isPasswordHidden) {
        isPasswordHidden = false;
      } else {
        isPasswordHidden = true;
      }
    });
  }

  void loginToApp() {
    if (loginFormKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        LoginButtonPressed(
          email: emailController.text,
          password: passwordController.text,
        ),
      );
    } else {
      print("failed to validate");
    }
  }

  void handleApiResponse(BuildContext context, Object? state) async {
    if (state is LoginSuccess) {
      await authBox.put(HiveKeys.userBox, jsonEncode(state.user.toJson()));
      await authBox.put(HiveKeys.accessToken, state.token);

      if (!mounted) return;

      /// Clear the stack and navigate to Home
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home, // Ensure this route is correctly defined
        (route) => false,
      );
    }
  }

  void buySubscription(User user) async{
    await authBox.put(HiveKeys.userBox, jsonEncode(user.toJson()));
    Navigator.pushNamed(context, "/subscriptions");
  }

  @override
  Widget build(BuildContext context) => Login(this);
}
