import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import 'package:meta/meta.dart';

import '../../../../core/config/config.dart';
import '../../../core/local/hive_constants.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  List<BluetoothInfo> pairedPrinters = [];
  BluetoothInfo? selectedPrinter;

  SettingsBloc() : super(SettingsInitial()) {
    on<LoadPrinters>(_onLoadPrinters);
    on<SelectPrinter>(_onSelectPrinter);
  }

  Future<void> _onLoadPrinters(LoadPrinters event, Emitter emit) async {
    final userSettings = await authBox.get(HiveKeys.settingsBox);
    final settings = jsonDecode(userSettings ?? '{}');
    final savedAddress = settings['printer_connected'];

    final List<BluetoothInfo> bondedDevices =
    await PrintBluetoothThermal.pairedBluetooths;

    pairedPrinters = bondedDevices;

    if (savedAddress != null) {
      try {
        selectedPrinter = pairedPrinters.firstWhere(
              (d) => d.macAdress == savedAddress,
        );
      } catch (e) {
        selectedPrinter = null;
      }
    }

    emit(PrintersLoaded(pairedPrinters, selectedPrinter));
  }


  Future<void> _onSelectPrinter(SelectPrinter event, Emitter emit) async {
    selectedPrinter = event.device;

    // Get existing settings or initialize if null
    final userSettings = await authBox.get(HiveKeys.settingsBox);
    Map<String, dynamic> settings = {};

    if (userSettings != null) {
      try {
        settings = jsonDecode(userSettings);
      } catch (e) {
        settings = {};
      }
    }

    settings['printer_connected'] = selectedPrinter!.macAdress;
    await authBox.put(HiveKeys.settingsBox, jsonEncode(settings));

    emit(PrintersLoaded(pairedPrinters, selectedPrinter));
  }
}
