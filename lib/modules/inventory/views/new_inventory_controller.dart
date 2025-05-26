library new_inventory_library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/config/config.dart';
import '../../../../core/local/hive_constants.dart';
import '../../../../core/widgets/base_widget.dart';

import '../../../core/widgets/base_screen.dart';
import '../../auth/models/User.dart';
import '../bloc/inventory_bloc.dart';

part 'new_inventory_screen.dart';

class NewInventoryController extends StatefulWidget {
  const NewInventoryController({super.key});

  @override
  State<NewInventoryController> createState() => NewInventoryControllerState();
}

class NewInventoryControllerState extends State<NewInventoryController> {
  String _scanBarcode = "";
  String name = "";
  String email = "";
  void initAuthCred() async {
    String userJson = authBox.get(HiveKeys.userBox);
    User user = User.fromJson(jsonDecode(userJson));
    setState(() {
      name = user.name;
      email = user.email;
    });
  }

  Future<void> scanBarcode(BuildContext context, TextEditingController skuController) async {
    String barcodeScanRes = '';

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text("Scan Barcode")),
          body: MobileScanner(
            onDetect: (barcodeCapture) {
              final Barcode? barcode = barcodeCapture.barcodes.first;
              if (barcode?.rawValue != null) {
                barcodeScanRes = barcode!.rawValue!;
                Navigator.pop(context, barcodeScanRes);
              }
            },
          ),
        ),
      ),
    );

    if (barcodeScanRes.isNotEmpty) {
      skuController.text = barcodeScanRes;
    }
  }


  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController skuController = TextEditingController();
  void createInventory() {
    if (formKey.currentState!.validate()) {
      var name = nameController.text.toString();
      var quantity = quantityController.text.toString();
      var sku = skuController.text.toString();

      BlocProvider.of<InventoryBloc>(context)
          .add(AddInventory(sku: sku, quantity: double.tryParse(quantity)!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form submitted successfully!')),
      );
    }
    print("submit linked to controller");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAuthCred();
  }

  @override
  Widget build(BuildContext context) => NewInventoryScreen(this);
}
