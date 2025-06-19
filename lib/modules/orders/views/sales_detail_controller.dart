library sales_detail_library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/widgets.dart' as pw;
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

  Future<void> printInvoice(String print_invoice) async {
    final intent = AndroidIntent(
      action: 'android.intent.action.SEND',
      package: 'ru.a402d.rawbtprinter',
      type: 'text/plain',
      arguments: {
        'android.intent.extra.TEXT': "${print_invoice}",
      },
    );
    intent.launch();
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
