import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/config/config.dart';
import '../../../../core/local/hive_constants.dart';
import '../../auth/models/User.dart';
import '../Dio/customer_repository.dart';
import '../models/customers_model.dart';

part 'customers_event.dart';

part 'customers_state.dart';

class CustomersBloc extends Bloc<CustomersEvent, CustomersState> {
  CustomerRepositoryImpl customerRepositoryImpl = CustomerRepositoryImpl();

  CustomersBloc() : super(CustomersInitial()) {
    on<LoadCustomersList>(_loadCustomersList);
    on<LoadCustomers>(_loadCustomers);
    on<LoadCustomer>(_loadCustomer);
    on<NewCustomerCreate>(_newCustomer);
    on<UpdateCustomer>(_updateCustomer);
  }

  void _loadCustomersList(
    LoadCustomersList event,
    Emitter<CustomersState> emit,
  ) async {
    try {
      emit(LoadingCustomers());
      String userString = await authBox.get(HiveKeys.userBox);
      String token = await authBox.get(HiveKeys.accessToken);
      User user = User.fromJson(jsonDecode(userString));
      print('user org id: ${user.orgId}');
      final response = await customerRepositoryImpl.fetchCustomers(
        user.orgId!,
        token,
      );
      if (response == null || response.data == null) {
        emit(LoadCustomersFailure("No response from server"));
        return;
      }

      // Ensure data is always a Map<String, dynamic>
      final data =
          response.data['data'] is String
              ? jsonDecode(response.data['data'])
              : response.data['data'];
      if (response.data["subscriptionError"] == 1) {
        emit(CustomerSubscriptionFailure(response.data['message']));
        return;
      }
      if (data is List<Map<String, dynamic>>) {}
      final List<Customer> customers = customerFromJson(jsonEncode(data));
      Customer falseCustomer = Customer(
        id: 0,
        orgId: 0,
        customerName: "Select Customer",
        customerAddress: "",
        customerPhoneNumber: "",
        customerPic: "customerPic",
        customerActive: 1,
        customerType: 0,
        createdAt: "createdAt",
        updatedAt: "updatedAt",
      );
      customers.insert(0, falseCustomer);
      print(response.statusCode);
      if (response.statusCode == 401) {
        emit(LoadCustomersFailure("Login failed."));
        return;
      }
      if (response.statusCode == 202) {
        emit(LoadCustomersFailure(response.data['message']));
        return;
      }
      emit(LoadCustomersSuccess(customers));
    } catch (e, stacktrace) {
      print('Exception in bloc:$e');
      print('Stacktrace: $stacktrace');
      emit(LoadCustomersFailure("An error occurred."));
    }
    return;
  }

  void _loadCustomer(LoadCustomer event, Emitter<CustomersState> emit) async {
    try {
      emit(LoadingCustomers());
      String userString = await authBox.get(HiveKeys.userBox);
      String token = await authBox.get(HiveKeys.accessToken);
      User user = User.fromJson(jsonDecode(userString));
      print('user org id: ${user.orgId}');
      int customer_id = event.customer_id;
      print("customer id: ${customer_id}");
      final response = await customerRepositoryImpl.fetchCustomers(
        user.orgId!,
        token,
        customerId: customer_id,
      );
      if (response == null || response.data == null) {
        emit(LoadCustomersFailure("No response from server"));
        return;
      }

      // Ensure data is always a Map<String, dynamic>
      final data =
          response.data['data'] is String
              ? jsonDecode(response.data['data'])
              : response.data['data'];
      print(data);

      Customer customer = Customer.fromJson(data);

      if (response.statusCode == 401) {
        emit(LoadCustomersFailure("Login failed."));
        return;
      }
      if (response.statusCode == 202) {
        emit(LoadCustomersFailure(response.data['message']));
        return;
      }
      emit(CustomerLoaded(customer));
    } catch (e, stacktrace) {
      print('Exception in bloc:$e');
      print('Stacktrace: $stacktrace');
      emit(LoadCustomersFailure("An error occurred."));
    }
    return;
  }

  void _loadCustomers(LoadCustomers event, Emitter<CustomersState> emit) async {
    try {
      emit(LoadingCustomers());
      String userString = await authBox.get(HiveKeys.userBox);
      String token = await authBox.get(HiveKeys.accessToken);
      User user = User.fromJson(jsonDecode(userString));
      print('user org id: ${user.orgId}');
      final response = await customerRepositoryImpl.fetchCustomers(
        user.orgId!,
        token,
      );
      if (response == null || response.data == null) {
        emit(LoadCustomersFailure("No response from server"));
        return;
      }

      // Ensure data is always a Map<String, dynamic>
      final data =
          response.data['data'] is String
              ? jsonDecode(response.data['data'])
              : response.data['data'];
      if (response.data["subscriptionError"] == 1) {
        emit(CustomerSubscriptionFailure(response.data['message']));
        return;
      }
      final List<Customer> customers = customerFromJson(jsonEncode(data));

      if (response.statusCode == 401) {
        emit(LoadCustomersFailure("Login failed."));
        return;
      }
      if (response.statusCode == 202) {
        emit(LoadCustomersFailure(response.data['message']));
        return;
      }
      emit(LoadCustomersSuccess(customers));
    } catch (e, stacktrace) {
      print('Exception in bloc:$e');
      print('Stacktrace: $stacktrace');
      emit(LoadCustomersFailure("An error occurred."));
    }
    return;
  }

  void _newCustomer(
    NewCustomerCreate event,
    Emitter<CustomersState> emit,
  ) async {
    try {
      emit(CreatingNewCustomer());
      String userString = await authBox.get(HiveKeys.userBox);
      String token = await authBox.get(HiveKeys.accessToken);
      User user = User.fromJson(jsonDecode(userString));
      String customer_name = event.customer_name;
      String customer_address = event.customer_address;
      String customer_phone_number = event.customer_phone_number;
      File? customer_image = event.customer_image;
      int customer_active = event.customer_active;
      int customer_type = event.customer_type;
      final response = await customerRepositoryImpl.createCustomers(
        user.orgId!,
        customer_name,
        customer_address,
        customer_phone_number,
        customer_image != null ? customer_image : null,
        customer_active,
        customer_type,
        token,
      );
      if (response == null || response.data == null) {
        emit(NewCustomerCreateFailure("No response from server"));
        return;
      }

      // Ensure data is always a Map<String, dynamic>
      final data =
          response.data['data'] is String
              ? jsonDecode(response.data['data'])
              : response.data['data'];
      print(data);
      final Customer customers = Customer.fromJson(data);

      if (response.statusCode == 401) {
        emit(NewCustomerCreateFailure("Login failed."));
        return;
      }
      if (response.statusCode == 422) {
        emit(NewCustomerCreateFailure(response.data['message']));
        return;
      }
      emit(NewCustomerCreateSuccess(customers));
    } catch (e, stacktrace) {
      print('Exception in bloc:$e');
      print('Stacktrace: $stacktrace');
      emit(NewCustomerCreateFailure("An error occurred."));
    }
    return;
  }

  void _updateCustomer(
    UpdateCustomer event,
    Emitter<CustomersState> emit,
  ) async {
    try {
      emit(CreatingNewCustomer());
      String userString = await authBox.get(HiveKeys.userBox);
      String token = await authBox.get(HiveKeys.accessToken);
      User user = User.fromJson(jsonDecode(userString));
      int id = event.id;
      String customer_name = event.customer_name;
      String customer_address = event.customer_address;
      String customer_phone_number = event.customer_phone_number;
      File? customer_image = event.customer_image;
      int customer_active = event.customer_active;
      int customer_type = event.customer_type;

      final response = await customerRepositoryImpl.updateCustomers(
        id,
        user.orgId!,
        customer_name,
        customer_address,
        customer_phone_number,
        customer_image,
        customer_active,
        customer_type,
        token,
      );
      if (response == null || response.data == null) {
        emit(NewCustomerCreateFailure("No response from server"));
        return;
      }

      // Ensure data is always a Map<String, dynamic>
      final data =
          response.data['data'] is String
              ? jsonDecode(response.data['data'])
              : response.data['data'];
      print("status  code: ${response.statusCode}");
      if (response.statusCode == 422) {
        print("response at 422: ${response.data['message']}");
        emit(NewCustomerCreateFailure(response.data['message']));
        return;
      }
      final Customer customers = Customer.fromJson(data);

      if (response.statusCode == 401) {
        emit(NewCustomerCreateFailure("Login failed."));
        return;
      }
      emit(NewCustomerCreateSuccess(customers));
    } catch (e, stacktrace) {
      print('Exception in bloc:$e');
      print('Stacktrace: $stacktrace');
      emit(NewCustomerCreateFailure("An error occurred."));
    }
    return;
  }
}
