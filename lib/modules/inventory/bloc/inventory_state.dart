part of 'inventory_bloc.dart';

@immutable
sealed class InventoryState {}

final class InventoryInitial extends InventoryState {}

class LoadInventorySuccess extends InventoryState {
  final List<InventoryModel> response;

  LoadInventorySuccess(this.response);
}

class LoadInventoryFailure extends InventoryState {
  final String error;

  LoadInventoryFailure(this.error);
}

class AddInventorySuccess extends InventoryState {
  final InventoryModel response;

  AddInventorySuccess(this.response);
}

class AddInventoryFailure extends InventoryState {
  final String error;

  AddInventoryFailure(this.error);
}

class LoadInventoryDetailSuccess extends InventoryState {
  final InventoryModel response;

  LoadInventoryDetailSuccess(this.response);
}

class LoadInventoryDetailFailure extends InventoryState {
  final String error;

  LoadInventoryDetailFailure(this.error);
}

class LoadingInventoryDetail extends InventoryState {
  LoadingInventoryDetail();
}

class LoadingInventoryList extends InventoryState {
  LoadingInventoryList();
}
class InventorySubscriptionFailure extends InventoryState{
  final String message;
  InventorySubscriptionFailure(this.message);
}