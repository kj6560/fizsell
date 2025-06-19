part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {}

class LoadPrinters extends SettingsEvent {}

class SelectPrinter extends SettingsEvent {
  final BluetoothInfo device;

  SelectPrinter(this.device);
}

class LoadCurrencies extends SettingsEvent {}

class SetCurrency extends SettingsEvent {
  final int currencyId;

  SetCurrency(this.currencyId);
}
