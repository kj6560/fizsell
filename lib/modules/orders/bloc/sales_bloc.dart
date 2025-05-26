import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/config/config.dart';
import '../../../../core/local/hive_constants.dart';
import '../../auth/models/User.dart';
import '../../products/models/products_model.dart';
import '../Dio/sales_repository.dart';
import '../models/sales_model.dart';

part 'sales_event.dart';
part 'sales_state.dart';

class SalesBloc extends Bloc<SalesEvent, SalesState> {
  SaleRepositoryImpl saleRepositoryImpl = SaleRepositoryImpl();

  SalesBloc() : super(SalesInitial()) {
    on<LoadSalesList>(_loadSales);
    on<NewSale>(_newSales);
    on<NewSalesInit>(_salesInit);
    on<LoadSalesDetail>(_loadDetail);
    on<FetchProductDetail>(_fetchProductDetail);
  }

  void _loadSales(LoadSalesList event, Emitter<SalesState> emit) async {
    try {
      emit(LoadingSalesList());
      String userString = await authBox.get(HiveKeys.userBox);
      String token = await authBox.get(HiveKeys.accessToken);
      User user = User.fromJson(jsonDecode(userString));
      print('user org id: ${user.orgId}');
      final response = await saleRepositoryImpl.fetchOrder(user.orgId!, token);
      if (response == null || response.data == null) {
        emit(LoadSalesFailure("No response from server"));
        return;
      }

      // Ensure data is always a Map<String, dynamic>
      final data = response.data['data'] is String
          ? jsonDecode(response.data['data'])
          : response.data['data'];

      final List<SalesModel> inventories = salesModelFromJson(jsonEncode(data));

      if (response.statusCode == 401) {
        emit(LoadSalesFailure("Login failed."));
        return;
      }
      if (response.statusCode == 202) {
        emit(LoadSalesFailure(response.data['message']));
        return;
      }
      emit(LoadSalesSuccess(inventories));
    } catch (e, stacktrace) {
      print('Exception in bloc: $e');
      print('Stacktrace: $stacktrace');
      emit(LoadSalesFailure("An error occurred."));
    }
    return;
  }

  void _newSales(NewSale event, Emitter<SalesState> emit) async {
    try {
      String userString = await authBox.get(HiveKeys.userBox);
      String token = await authBox.get(HiveKeys.accessToken);
      User user = User.fromJson(jsonDecode(userString));
      String payload = event.payload;
      int payment_method = event.payment_method;
      int customer_id = event.customer_id;
      final response = await saleRepositoryImpl.newOrder(
          user.orgId!, user.id, payload, payment_method, customer_id, token);
      if (response == null || response.data == null) {
        emit(NewSalesFailure("No response from server"));
        return;
      }
      // Ensure data is always a Map<String, dynamic>
      final data = response.data['data'] is String
          ? jsonDecode(response.data['data'])
          : response.data['data'];
      final SalesModel order = SalesModel.fromJson(data);

      if (response.statusCode == 401) {
        emit(NewSalesFailure("Login failed."));
        return;
      }
      emit(NewSalesSuccess(order));
    } catch (e, stacktrace) {
      print('Exception in bloc: $e');
      print('Stacktrace: $stacktrace');
      emit(NewSalesFailure("An error occurred."));
    }
    return;
  }

  void _salesInit(NewSalesInit event, Emitter<SalesState> emit) async {}

  void _loadDetail(LoadSalesDetail event, Emitter<SalesState> emit) async {
    int orderId = event.orderId;
    try {
      emit(LoadingSalesDetail());
      String userString = await authBox.get(HiveKeys.userBox);
      String token = await authBox.get(HiveKeys.accessToken);
      User user = User.fromJson(jsonDecode(userString));
      print('user org id: ${user.orgId}');
      final response = await saleRepositoryImpl.fetchOrder(user.orgId!, token,
          orderId: orderId);
      if (response == null || response.data == null) {
        emit(LoadSalesFailure("No response from server"));
        return;
      }

      // Ensure data is always a Map<String, dynamic>
      final data = response.data['data'] is String
          ? jsonDecode(response.data['data'])
          : response.data['data'];
      print(data);
      final SalesModel detail = SalesModel.fromJson(data);

      if (response.statusCode == 401) {
        emit(LoadSalesFailure("Login failed."));
        return;
      }
      emit(LoadSalesDetailsSuccess(detail));
    } catch (e, stacktrace) {
      print('Exception in bloc: $e');
      print('Stacktrace: $stacktrace');
      emit(LoadSalesFailure("An error occurred."));
    }
    return;
  }

  FutureOr<void> _fetchProductDetail(
      FetchProductDetail event, Emitter<SalesState> emit) async {
    try {
      emit(FetchingProductDetail());
      String userString = await authBox.get(HiveKeys.userBox);
      String token = await authBox.get(HiveKeys.accessToken);
      User user = User.fromJson(jsonDecode(userString));
      String product_sku = event.product_sku;
      print(product_sku);
      final response = await saleRepositoryImpl
          .fetchProducts(user.orgId!, token, product_sku: product_sku);
      if (response == null || response.data == null) {
        emit(ProductDetailFetchFailure("No response from server"));
        return;
      }
      // Ensure data is always a Map<String, dynamic>
      final data = response.data['data'] is String
          ? jsonDecode(response.data['data'])
          : response.data['data'];
      print(data);
      final Product product = Product.fromJson(data);

      if (response.statusCode == 401) {
        emit(ProductDetailFetchFailure("Login failed."));
        return;
      }
      emit(ProductDetailFetchSuccess(product));
    } catch (e, stacktrace) {
      print('Exception in bloc: $e');
      print('Stacktrace: $stacktrace');
      emit(ProductDetailFetchFailure("An error occurred."));
    }
    return;
  }
}
