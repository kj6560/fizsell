library sales_list_library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/config.dart';
import '../../../../core/local/hive_constants.dart';
import '../../../../core/routes.dart';
import '../../../../core/widgets/base_screen.dart';
import '../../../../core/widgets/base_widget.dart';
import '../../../core/utils/Helpers.dart';
import '../../auth/models/User.dart';
import '../bloc/sales_bloc.dart';
import '../models/sales_model.dart';

part 'sales_list_screen.dart';

class SalesListController extends StatefulWidget {
  const SalesListController({super.key});

  @override
  State<SalesListController> createState() => SalesListControllerState();
}

class SalesListControllerState extends State<SalesListController> {
  String name = "";
  String email = "";
  bool hasActiveSubscription = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAuthCred();
    BlocProvider.of<SalesBloc>(context).add(LoadSalesList());
  }
  void reset() {
    BlocProvider.of<SalesBloc>(context).add(LoadSalesList());
  }
  void initAuthCred() async {
    String userJson = authBox.get(HiveKeys.userBox);
    User user = User.fromJson(jsonDecode(userJson));
    setState(() {
      name = user.name;
      email = user.email;
    });
  }

  void changeSubscriptionStatus(bool status) {
    setState(() {
      hasActiveSubscription = status;
    });
  }

  @override
  Widget build(BuildContext context) => SalesListUi(this);
}
