library product_detail_library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/config.dart';
import '../../../../core/local/hive_constants.dart';
import '../../../../core/routes.dart';
import '../../../core/widgets/base_screen.dart';
import '../../../core/widgets/base_widget.dart';
import '../../auth/models/User.dart';
import '../bloc/product_bloc.dart';
part 'product_detail_screen.dart';

class ProductDetailController extends StatefulWidget {
  const ProductDetailController({super.key});

  @override
  State<ProductDetailController> createState() =>
      ProductDetailControllerState();
}

class ProductDetailControllerState extends State<ProductDetailController> {
  String name = "";
  String email = "";
  String product_id = "";

  @override
  void initState() {
    super.initState();
    _getArguments();
    initAuthCred();
  }

  void _getArguments() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = ModalRoute.of(context);
      if (route == null) {
        return;
      }

      final args = route.settings.arguments;
      if (args == null) {
        return;
      }
      if (args is Map<String, dynamic> && args.containsKey("product_id")) {
        String productId = args["product_id"].toString();
        setState(() {
          product_id = productId;
        });

        BlocProvider.of<ProductBloc>(context)
            .add(LoadProductDetail(product_id: product_id));
      }
    });
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
    return ProductDetailScreen(this);
  }

  void deleteProduct() {
    BlocProvider.of<ProductBloc>(context)
        .add(DeleteProduct(id: int.parse(product_id)));
  }

  void postDelete() {
    Navigator.popAndPushNamed(context, AppRoutes.home);
  }
}
