library settings_library;

import 'dart:convert';

import 'package:fizsell/modules/Settings/views/currency_settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:fizsell/modules/Users/views/users_list_controller.dart';

import '../../../../core/config/config.dart';
import '../../../../core/local/hive_constants.dart';
import '../../../core/widgets/base_screen.dart';
import '../../../core/widgets/base_widget.dart';
import '../../auth/models/User.dart';
import '../bloc/settings_bloc.dart';
import 'PrinterSelectionScreen.dart';

part 'settings_screen.dart';

class SettingsController extends StatefulWidget {
  const SettingsController({super.key});

  @override
  State<SettingsController> createState() => SettingsControllerState();
}

class SettingsControllerState extends State<SettingsController> {
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

  @override
  void initState() {
    super.initState();
    initAuthCred();
    requestBluetoothPermissions();
  }

  Future<void> requestBluetoothPermissions() async {
    if (await Permission.bluetoothConnect.isDenied) {
      await Permission.bluetoothConnect.request();
    }

    if (await Permission.bluetoothScan.isDenied) {
      await Permission.bluetoothScan.request();
    }

    // Optional: Location for older Android versions
    if (await Permission.location.isDenied) {
      await Permission.location.request();
    }
    //context.read<SettingsBloc>().add(LoadPrinters());
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(this);
  }
}
