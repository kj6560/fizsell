import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fizsell/modules/products/views/products_list.dart';

import '../../../core/config/config.dart';
import '../../../core/local/hive_constants.dart';
import '../../../core/widgets/base_screen.dart';
import '../../auth/models/User.dart';
import '../bloc/product_bloc.dart';
class ProductsListController extends StatefulWidget {
  const ProductsListController({super.key});

  @override
  State<ProductsListController> createState() => ProductsListControllerState();
}

class ProductsListControllerState extends State<ProductsListController> {
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

  @override
  Widget build(BuildContext context) {
    return ProductsList(this);
  }

  void reset() {
    BlocProvider.of<ProductBloc>(context).add(LoadProductList());
  }
}