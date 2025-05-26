library new_scheme_library;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/config.dart';
import '../../../../core/local/hive_constants.dart';
import '../../../../core/routes.dart';
import '../../../core/widgets/base_screen.dart';
import '../../../core/widgets/base_widget.dart';
import '../../auth/models/User.dart';
import '../bloc/scheme_bloc.dart';

part 'new_scheme_screen.dart';

class NewSchemeController extends StatefulWidget {
  const NewSchemeController({super.key});

  @override
  State<NewSchemeController> createState() => NewSchemeControllerState();
}

class NewSchemeControllerState extends State<NewSchemeController> {
  String name = "";
  String email = "";
  final _formKey = GlobalKey<FormState>();

  TextEditingController schemeNameController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  String schemeType = 'combo'; // Default type
  bool isActive = true;
  DateTime? startDate;
  DateTime? endDate;

  List<Map<String, dynamic>> bundleProducts = [];

  int mainProduct = 0;
  void setMainProductId(int productId) {
    setState(() {
      mainProduct = productId;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  void addBundleProduct() {
    setState(() {
      bundleProducts.add({"product_id": null, "quantity": 1});
    });
  }

  void removeBundleProduct(int index) {
    setState(() {
      bundleProducts.removeAt(index);
    });
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      String userJson = authBox.get(HiveKeys.userBox);
      User user = User.fromJson(jsonDecode(userJson));
      Map<String, dynamic> schemeData = {
        "product_id": mainProduct, // Replace with actual selected product
        "org_id": user.orgId, // Replace with actual org ID
        "scheme_name": schemeNameController.text,
        "type": schemeType,
        "value": double.parse(valueController.text),
        "duration": durationController.text.isNotEmpty
            ? int.parse(durationController.text)
            : null,
        "start_date": startDate?.toIso8601String().substring(0, 10),
        "end_date": endDate?.toIso8601String().substring(0, 10),
        "is_active": isActive,
        "bundle_products":
            bundleProducts.where((p) => p["product_id"] != null).toList(),
      };
      BlocProvider.of<SchemeBloc>(context)
          .add(CreateNewScheme(payload: schemeData));
      print("Scheme Data: $schemeData");
    }
  }

  void onSchemeCreated(SchemeState state) {
    Navigator.popAndPushNamed(context, AppRoutes.listSchemes);
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
  void initState() {
    // TODO: implement initState
    super.initState();
    initAuthCred();
    BlocProvider.of<SchemeBloc>(context).add(LoadProductList());
  }

  @override
  Widget build(BuildContext context) {
    return NewSchemeScreen(this);
  }

  void setIsActive(bool? value) {
    setState(() {
      isActive = value!;
    });
  }
}
