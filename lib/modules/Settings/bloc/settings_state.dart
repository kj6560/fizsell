part of 'settings_bloc.dart';

@immutable
abstract class SettingsState {}

class SettingsInitial extends SettingsState {}
class LoadingCurrencies extends SettingsState {}
class PrintersLoaded extends SettingsState {
  final List<BluetoothInfo> pairedPrinters;
  final BluetoothInfo? selectedPrinter;

  PrintersLoaded(this.pairedPrinters, this.selectedPrinter);
}
class LoadCurrenciesSuccess extends SettingsState {
  final List<Currency> currencies;
  final int? selectedCurrency;
  LoadCurrenciesSuccess(this.currencies,this.selectedCurrency);
}

class LoadCurrenciesFailure extends SettingsState {
  final String error;

  LoadCurrenciesFailure(this.error);
}
class SettingCurrency extends SettingsState{}
class CurrencySetSuccessful extends SettingsState{
  final String msg;
  CurrencySetSuccessful(this.msg);
}
class CurrencySetFailure extends SettingsState{
  final String error;
  CurrencySetFailure(this.error);
}