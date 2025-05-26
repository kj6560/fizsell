library inventory_detail_library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/config.dart';
import '../../../../core/local/hive_constants.dart';
import '../../../../core/routes.dart';
import '../../../core/widgets/base_screen.dart';
import '../../../core/widgets/base_widget.dart';
import '../../auth/models/User.dart';
import '../bloc/inventory_bloc.dart';
import '../models/inventory_model.dart';

part 'inventory_detail_screen.dart';

class InventoryDetailController extends StatefulWidget {
  const InventoryDetailController({super.key});

  @override
  State<InventoryDetailController> createState() =>
      InventoryDetailControllerState();
}

class InventoryDetailControllerState extends State<InventoryDetailController> {
  String name = "";
  String email = "";
  String inventory_id = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getArguments();
    initAuthCred();
  }

  void _getArguments() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = ModalRoute.of(context);
      if (route == null) {
        print("❌ ModalRoute is NULL. Arguments not passed?");
        return;
      }

      final args = route.settings.arguments;
      if (args == null) {
        print("❌ Arguments are NULL. Check if Navigator is passing arguments.");
        return;
      }

      print("✅ Arguments found: $args");

      if (args is Map<String, dynamic> && args.containsKey("inventory_id")) {
        String inventoryId = args["inventory_id"].toString();
        print("✅ Order ID: $inventoryId"); // Debugging

        setState(() {
          inventory_id = inventoryId;
        });

        BlocProvider.of<InventoryBloc>(context)
            .add(LoadInventoryDetail(inventory_id: int.parse(inventory_id)));
      } else {
        print("❌ Arguments exist but 'sales_id' is missing.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InventoryDetailScreen(this);
  }

  void initAuthCred() async {
    String userJson = authBox.get(HiveKeys.userBox);
    User user = User.fromJson(jsonDecode(userJson));
    setState(() {
      name = user.name;
      email = user.email;
    });
  }
}
