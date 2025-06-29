library new_sale_library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/config/config.dart';
import '../../../../core/local/hive_constants.dart';
import '../../../../core/widgets/base_screen.dart';
import '../../../../core/widgets/base_widget.dart';
import '../../../core/routes.dart';
import '../../auth/models/User.dart';
import '../../customers/bloc/customers_bloc.dart';
import '../../customers/models/customers_model.dart';
import '../../products/models/AppliedScheme.dart';
import '../../products/models/products_model.dart';
import '../bloc/sales_bloc.dart';
import '../models/new_order_model.dart';

part 'new_sale_screen.dart';

class NewSaleController extends StatefulWidget {
  const NewSaleController({super.key});

  @override
  State<NewSaleController> createState() => NewSaleControllerState();
}

class NewSaleControllerState extends State<NewSaleController> {

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
  List<NewOrder> orders = [];
  TextEditingController quantityController = TextEditingController();
  TextEditingController skuController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  String name = "";
  String email = "";
  String? selectedValue = "Cash"; // Holds the selected dropdown value
  List<String> dropdownItems = ["Payment Mode", "Cash", "Credit"];
  Customer? selectedUser;

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
    super.initState();
    initAuthCred();
    context.read<CustomersBloc>().add(LoadCustomersList());
  }

  void updateOrder(NewOrder newOrder) {
    setState(() {
      // Check if the SKU already exists in the list
      int existingIndex =
          orders.indexWhere((order) => order.sku == newOrder.sku);

      if (existingIndex != -1) {
        // SKU exists, update the quantity
        orders[existingIndex] = NewOrder(
            product_name: orders[existingIndex].product_name,
            product_mrp: orders[existingIndex].product_mrp,
            sku: orders[existingIndex].sku,
            quantity: orders[existingIndex].quantity + newOrder.quantity,
            discount: orders[existingIndex].discount,
            tax: orders[existingIndex].tax,
            schemes: orders[existingIndex].schemes);
      } else {
        // SKU doesn't exist, add a new order
        orders.add(newOrder);
      }
    });
  }

  Future<bool> submitOrder() async {
    print(newOrderToJson(orders));
    int payMethod = 1;
    if (selectedValue == "Cash") {
      payMethod = 1;
    } else if (selectedValue == "Credit") {
      payMethod = 2;
    }
    BlocProvider.of<SalesBloc>(context).add(NewSale(
        payload: newOrderToJson(orders),
        payment_method: payMethod,
        customer_id: selectedUser!.id));
    return true;
  }

  @override
  Widget build(BuildContext context) => NewSaleScreen(this);

  void removeOrderItem(NewOrder newOrder) {
    setState(() {
      // Check if the SKU already exists in the list
      int existingIndex =
          orders.indexWhere((order) => order.sku == newOrder.sku);

      if (existingIndex != -1) {
        // SKU exists, update the quantity
        orders.removeWhere((order) => order.sku == newOrder.sku);
      } else {
        // SKU doesn't exist, add a new order
        orders.add(newOrder);
      }
    });
  }

  void resetDialog() {
    qtyController.text = "";
    discountController.text = "0.0";
    taxController.text = "0.0";
  }

  void updatePaymentMode(String? newValue) {
    setState(() {
      selectedValue = newValue;
    });
  }
}
