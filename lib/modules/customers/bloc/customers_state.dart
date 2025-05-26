part of 'customers_bloc.dart';

@immutable
sealed class CustomersState {}

final class CustomersInitial extends CustomersState {}

class LoadCustomersSuccess extends CustomersState {
  final List<Customer> response;

  LoadCustomersSuccess(this.response);
}

class LoadCustomersFailure extends CustomersState {
  final String error;

  LoadCustomersFailure(this.error);
}

class LoadingCustomers extends CustomersState {
  LoadingCustomers();
}

class NewCustomerCreateSuccess extends CustomersState {
  final Customer customer;

  NewCustomerCreateSuccess(this.customer);
}

class NewCustomerCreateFailure extends CustomersState {
  final String error;

  NewCustomerCreateFailure(this.error);
}

class CreatingNewCustomer extends CustomersState {}

class UpdatingCustomer extends CustomersState {}

class UpdateCustomerSuccess extends CustomersState {
  final Customer customer;

  UpdateCustomerSuccess(this.customer);
}

class UpdateCustomerFailure extends CustomersState {
  final String error;

  UpdateCustomerFailure(this.error);
}

class CustomerLoaded extends CustomersState {
  final Customer customer;
  CustomerLoaded(this.customer);
}
