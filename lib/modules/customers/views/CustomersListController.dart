library customers_list_library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/config.dart';
import '../../../../core/local/hive_constants.dart';
import '../../../../core/routes.dart';
import '../../../../core/widgets/base_screen.dart';
import '../../../../core/widgets/base_widget.dart';
import '../../auth/models/User.dart';
import '../bloc/customers_bloc.dart';
import '../models/customers_model.dart';

part 'customers_list_screen.dart';

class CustomersListController extends StatefulWidget {
  const CustomersListController({super.key});

  @override
  State<CustomersListController> createState() =>
      CustomersListControllerState();
}

class CustomersListControllerState extends State<CustomersListController> {
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
    BlocProvider.of<CustomersBloc>(context).add(LoadCustomers());
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
    return CustomersListScreen(this);
  }
}
