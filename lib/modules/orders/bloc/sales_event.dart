part of 'sales_bloc.dart';

abstract class SalesEvent extends Equatable {
  const SalesEvent();

  @override
  List<Object> get props => [];
}

class LoadSalesList extends SalesEvent {
  const LoadSalesList();
}

class NewSalesInit extends SalesEvent {
  NewSalesInit();
}

class NewSale extends SalesEvent {
  final String payload;
  final int payment_method;
  final int customer_id;
  const NewSale(
      {required this.payload,
      required this.payment_method,
      required this.customer_id});
}

class LoadSalesDetail extends SalesEvent {
  final int orderId;
  const LoadSalesDetail({required this.orderId});
}

class FetchProductDetail extends SalesEvent {
  final String product_sku;
  FetchProductDetail({required this.product_sku});
}
