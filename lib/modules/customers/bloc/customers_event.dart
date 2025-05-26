part of 'customers_bloc.dart';

abstract class CustomersEvent extends Equatable {
  const CustomersEvent();

  @override
  List<Object> get props => [];
}

class LoadCustomersList extends CustomersEvent {
  const LoadCustomersList();
}

class LoadCustomer extends CustomersEvent {
  final int customer_id;

  const LoadCustomer({required this.customer_id});
}

class LoadCustomers extends CustomersEvent {
  const LoadCustomers();
}

class NewCustomerCreate extends CustomersEvent {
  final String customer_name;
  final String customer_address;
  final String customer_phone_number;
  final int customer_active;
  final File customer_image;

  const NewCustomerCreate(
      {required this.customer_name,
      required this.customer_address,
      required this.customer_phone_number,
      required this.customer_image,
      required this.customer_active});
}

class UpdateCustomer extends CustomersEvent {
  final int id;
  final String customer_name;
  final String customer_address;
  final String customer_phone_number;
  final int customer_active;
  final File? customer_image;

  const UpdateCustomer(
      {required this.id,
      required this.customer_name,
      required this.customer_address,
      required this.customer_phone_number,
      this.customer_image,
      required this.customer_active});
}
