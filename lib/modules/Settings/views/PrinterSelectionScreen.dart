import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../bloc/settings_bloc.dart';

class PrinterSelectionScreen extends StatelessWidget {
  const PrinterSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Printer")),
      body: FutureBuilder<List<BluetoothInfo>>(
        future: PrintBluetoothThermal.pairedBluetooths,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final devices = snapshot.data!;
          return ListView(
            children: devices.map((device) {
              return ListTile(
                title: Text(device.name ?? "Unknown"),
                subtitle: Text(device.macAdress ?? ""),
                onTap: () {
                  context.read<SettingsBloc>().add(SelectPrinter(device));
                  Navigator.pop(context);
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
