library scheme_list_library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/config.dart';
import '../../../../core/local/hive_constants.dart';
import '../../../core/routes.dart';
import '../../../core/widgets/SubscriptionFailure.dart';
import '../../../core/widgets/base_screen.dart';
import '../../../core/widgets/base_widget.dart';
import '../../auth/models/User.dart';
import '../bloc/scheme_bloc.dart';
import '../models/scheme_model.dart';

part 'scheme_list_screen.dart';

class SchemeListController extends StatefulWidget {
  const SchemeListController({super.key});

  @override
  State<SchemeListController> createState() => SchemeListControllerState();
}

class SchemeListControllerState extends State<SchemeListController> {
  String name = "";
  String email = "";
  bool hasActiveSubscription = false;

  void changeSubscriptionStatus(bool status) {
    setState(() {
      hasActiveSubscription = status;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAuthCred();
    BlocProvider.of<SchemeBloc>(context).add(LoadSchemeList());
  }

  void initAuthCred() async {
    String userJson = authBox.get(HiveKeys.userBox);
    User user = User.fromJson(jsonDecode(userJson));
    setState(() {
      name = user.name;
      email = user.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SchemeListScreen(this);
  }
}
