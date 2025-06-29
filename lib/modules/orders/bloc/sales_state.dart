part of 'sales_bloc.dart';

@immutable
sealed class SalesState {}

final class SalesInitial extends SalesState {}

class LoadSalesSuccess extends SalesState {
  final List<SalesModel> response;

  LoadSalesSuccess(this.response);
}

class LoadSalesDetailsSuccess extends SalesState {
  final SalesModel response;

  LoadSalesDetailsSuccess(this.response);
}

class LoadSalesFailure extends SalesState {
  final String error;

  LoadSalesFailure(this.error);
}

class NewSalesSuccess extends SalesState {
  final SalesModel response;

  NewSalesSuccess(this.response);
}

class NewSalesFailure extends SalesState {
  final String error;

  NewSalesFailure(this.error);
}

class LoadingSalesList extends SalesState {
  LoadingSalesList();
}

class LoadingSalesDetail extends SalesState {
  LoadingSalesDetail();
}

class FetchingProductDetail extends SalesState {}

class ProductDetailFetchSuccess extends SalesState {
  final Product product;

  ProductDetailFetchSuccess(this.product);
}

class ProductDetailFetchFailure extends SalesState {
  final String error;
  ProductDetailFetchFailure(this.error);
}
class OrderSubscriptionFailure extends SalesState{
  final String message;
  OrderSubscriptionFailure(this.message);
}