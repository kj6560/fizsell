import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fizsell/modules/products/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/config.dart';
import '../../../core/config/endpoints.dart';
import '../../../core/local/hive_constants.dart';
import '../../../core/routes.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/models/User.dart';
import '../bloc/home_bloc.dart';
import 'home.dart';

class HomeController extends StatefulWidget {
  const HomeController({super.key});

  @override
  State<HomeController> createState() => HomeControllerState();
}

class HomeControllerState extends State<HomeController>
    with WidgetsBindingObserver {
  String name = "";
  String email = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initAuthCred();
    BlocProvider.of<HomeBloc>(context).add(HomeLoad());
    BlocProvider.of<ProductBloc>(context).add(LoadProductList());
  }

  void initAuthCred() async {
    String userJson = authBox.get(HiveKeys.userBox);
    User user = User.fromJson(jsonDecode(userJson));
    setState(() {
      name = user.name;
      email = user.email;
    });
  }

  Future<bool> forcelogout(BuildContext context) async {
    String userString = await authBox.get(HiveKeys.userBox);
    String token = await authBox.get(HiveKeys.accessToken);
    User user = User.fromJson(jsonDecode(userString));
    String userId = user.id.toString();

    try {
      Dio dio = Dio();
      Response response = await dio.get(
        '${EndPoints.logoutUrl}?user_id=$userId',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success']) {
        // Show forced logout dialog BEFORE clearing state
        await showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: Text("Logged Out"),
                content: Text(
                  response.data['message'] ??
                      "You were logged out due to login from another device.",
                ),
                actions: [
                  TextButton(
                    child: Text("OK"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
        );

        // Clear session and navigate to login
        await authBox.clear();
        BlocProvider.of<AuthBloc>(context).add(LoginReset());
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false,
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) => HomePage(this);
}
