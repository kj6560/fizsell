part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {}

class LoadPrinters extends SettingsEvent {}

class SelectPrinter extends SettingsEvent {
  final BluetoothInfo device;
  SelectPrinter(this.device);
}
