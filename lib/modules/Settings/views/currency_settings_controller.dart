library currency_settings_library;

import 'dart:convert';

import 'package:fizsell/modules/Settings/models/Currency.dart';
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

part 'currency_settings_screen.dart';

class CurrencySettingsController extends StatefulWidget {
  const CurrencySettingsController({super.key});

  @override
  State<CurrencySettingsController> createState() =>
      CurrencySettingsControllerState();
}

class CurrencySettingsControllerState
    extends State<CurrencySettingsController> {
  String name = "";
  String email = "";
  String? _selectedCurrency;
  int? selectedCurrencyId;
  String searchQuery = "";

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
    // or call setState in StatefulWidget if not using mixins
  }

  List<Currency> _currencies = [];

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
    BlocProvider.of<SettingsBloc>(context).add(LoadCurrencies());
  }

  void _onCurrencySelected(Currency currency) {
    setState(() {
      _selectedCurrency = currency.code;
      selectedCurrencyId = currency.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CurrencySettingsScreen(this);
  }

  void updateCurrencies(List<Currency> currencies, int? selectedCurrency) {
    setState(() {
      _currencies = currencies;
      selectedCurrencyId = selectedCurrency!;
    });
  }

  void setCurrency() {
    BlocProvider.of<SettingsBloc>(context).add(SetCurrency(selectedCurrencyId!));
  }

  void updated() {
    Navigator.popAndPushNamed(
        context,
        "/currencySettings"
    );
  }
}
