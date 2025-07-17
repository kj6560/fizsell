library inventory_library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/config.dart';
import '../../../../core/local/hive_constants.dart';
import '../../../../core/routes.dart';
import '../../../../core/widgets/base_screen.dart';
import '../../../../core/widgets/base_widget.dart';
import '../../auth/models/User.dart';
import '../bloc/inventory_bloc.dart';
import '../models/inventory_model.dart';

part 'inventory_list_screen.dart';

class InventoryListController extends StatefulWidget {
  const InventoryListController({super.key});

  @override
  State<InventoryListController> createState() =>
      InventoryListControllerState();
}

class InventoryListControllerState extends State<InventoryListController> {
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
    BlocProvider.of<InventoryBloc>(context).add(LoadInventoryList());
  }
  void reset() {
    BlocProvider.of<InventoryBloc>(context).add(LoadInventoryList());
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
  Widget build(BuildContext context) => InventoryListUi(this);
}
