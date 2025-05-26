part of 'settings_bloc.dart';

@immutable
abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class PrintersLoaded extends SettingsState {
  final List<BluetoothInfo> pairedPrinters;
  final BluetoothInfo? selectedPrinter;

  PrintersLoaded(this.pairedPrinters, this.selectedPrinter);
}
