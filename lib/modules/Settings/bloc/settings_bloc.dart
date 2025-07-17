import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:fizsell/modules/Settings/Dio/settings_repository.dart';
import 'package:fizsell/modules/Settings/models/Currency.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import 'package:meta/meta.dart';

import '../../../../core/config/config.dart';
import '../../../core/local/hive_constants.dart';
import '../../auth/models/User.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsRepositoryImpl settingsRepositoryImpl = SettingsRepositoryImpl();
  List<BluetoothInfo> pairedPrinters = [];
  BluetoothInfo? selectedPrinter;

  SettingsBloc() : super(SettingsInitial()) {
    // on<LoadPrinters>(_onLoadPrinters);
    on<SelectPrinter>(_onSelectPrinter);
    on<LoadCurrencies>(_onLoadCurrencies);
    on<SetCurrency>(_setCurrency);
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

  Future<void> _onLoadCurrencies(
    LoadCurrencies event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(LoadingCurrencies());
      String userString = await authBox.get(HiveKeys.userBox);
      String token = await authBox.get(HiveKeys.accessToken);
      User user = User.fromJson(jsonDecode(userString));
      final response = await settingsRepositoryImpl.fetchCurrencies(token);
      if (response == null || response.data == null) {
        emit(LoadCurrenciesFailure("No response from server"));
        return;
      }

      // Ensure data is always a Map<String, dynamic>
      final data =
          response.data['data'] is String
              ? jsonDecode(response.data['data'])
              : response.data['data'];
      final selectedId =
          response.data['selected'] != null || response.data['selected'] != ""
              ? response.data['selected']
              : 0;
      print("data is: ${response.data['selected']}");
      final List<Currency> currencies = currencyFromJson(jsonEncode(data));

      if (response.statusCode == 401) {
        emit(LoadCurrenciesFailure("Login failed."));
        return;
      }
      emit(
        LoadCurrenciesSuccess(
          currencies,
          selectedId == 0 ? 0 : int.parse(selectedId),
        ),
      );
    } catch (e, stacktrace) {
      print('Exception in bloc: $e');
      print('Stacktrace: $stacktrace');
      emit(LoadCurrenciesFailure("An error occurred."));
    }
    return;
  }

  FutureOr<void> _setCurrency(
    SetCurrency event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(SettingCurrency());
      String userString = await authBox.get(HiveKeys.userBox);
      String token = await authBox.get(HiveKeys.accessToken);
      User user = User.fromJson(jsonDecode(userString));
      int orgId = user.orgId;
      int currencyId = event.currencyId;
      final response = await settingsRepositoryImpl.setCurrency(
        orgId,
        token,
        currencyId,
      );
      if (response == null || response.data == null) {
        emit(CurrencySetFailure("No response from server"));
        return;
      }

      // Ensure data is always a Map<String, dynamic>
      final data =
          response.data['data'] is String
              ? jsonDecode(response.data['message'])
              : response.data['message'];

      if (response.statusCode == 401) {
        emit(CurrencySetFailure("Login failed."));
        return;
      }
      print("after set: ${data}");
      emit(CurrencySetSuccessful(data));
    } catch (e, stacktrace) {
      print('Exception in bloc: $e');
      print('Stacktrace: $stacktrace');
      emit(LoadCurrenciesFailure("An error occurred."));
    }
    return;
  }
}
