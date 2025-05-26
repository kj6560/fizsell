library sales_detail_library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../../../core/config/config.dart';
import '../../../../core/local/hive_constants.dart';
import '../../../core/widgets/base_screen.dart';
import '../../../core/widgets/base_widget.dart';
import '../../auth/models/User.dart';
import '../bloc/sales_bloc.dart';

part 'sales_detail_screen.dart';

class SalesDetailController extends StatefulWidget {
  const SalesDetailController({super.key});

  @override
  State<SalesDetailController> createState() => SalesDetailState();
}

class SalesDetailState extends State<SalesDetailController> {
  String name = "";
  String email = "";
  String? salesId;
  String? selectedPrinterAddress;

  @override
  void initState() {
    super.initState();
    _getArguments();
    initAuthCred();
  }

  void _getArguments() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = ModalRoute.of(context);
      if (route == null) return;

      final args = route.settings.arguments;
      if (args is Map<String, dynamic> && args.containsKey("sales_id")) {
        String orderId = args["sales_id"].toString();
        setState(() {
          salesId = orderId;
        });

        BlocProvider.of<SalesBloc>(context)
            .add(LoadSalesDetail(orderId: int.parse(orderId)));
      }
    });
  }

  void initAuthCred() async {
    String? userJson = authBox.get(HiveKeys.userBox);
    if (userJson != null) {
      User user = User.fromJson(jsonDecode(userJson));
      setState(() {
        name = user.name;
        email = user.email;
      });
    }
  }

  /// Scan and Save Printer
  /// Scan and Save Printer
  /// Scan and Save Printer
  Future<void> scanAndSavePrinter() async {
    try {
      List<BluetoothInfo> devices = await PrintBluetoothThermal.pairedBluetooths;

      if (devices.isNotEmpty) {
        BluetoothInfo selectedDevice = devices.first;

        String? macAddress = selectedDevice.macAdress;
        if (macAddress != null) {
          selectedPrinterAddress = macAddress;

          final userSettings = {
            "printer_connected": selectedPrinterAddress,
          };
          await authBox.put(HiveKeys.settingsBox, jsonEncode(userSettings));

          print("✅ Printer saved: $selectedPrinterAddress");
        } else {
          print("❌ macAddress not found in the selected device.");
        }
      } else {
        print("❌ No paired printers found.");
      }
    } catch (e) {
      print("❌ Error while scanning: $e");
    }
  }


  /// Print Invoice
  Future<void> printInvoice(String invoiceText) async {
    final userSettings = authBox.get(HiveKeys.settingsBox);
    if (userSettings == null) {
      _showNoPrinterDialog();
      return;
    }

    Map<String, dynamic> settings;
    try {
      settings = jsonDecode(userSettings);
    } catch (e) {
      print("❌ Failed to decode printer settings: $e");
      return;
    }

    final savedAddress = settings['printer_connected'];
    if (savedAddress == null) {
      print("❌ No printer saved.");
      return;
    }

    try {
      bool isConnected = await PrintBluetoothThermal.connectionStatus;
      if (isConnected) {
        await PrintBluetoothThermal.connect(macPrinterAddress: savedAddress);
      }

      Uint8List bytes = Uint8List.fromList(invoiceText.codeUnits);
      await PrintBluetoothThermal.writeBytes(bytes);

      print("✅ Invoice printed successfully.");
    } catch (e) {
      print("❌ Printing failed: $e");
    }
  }
  void _showNoPrinterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Printer Found'),
          content: Text('No printer settings were found. Please connect a printer first.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return SalesDetailScreen(this);
  }
}
