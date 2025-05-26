part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

class LoadProductSuccess extends ProductState {
  final List<Product> response;

  LoadProductSuccess(this.response);
}

class LoadProductListFailure extends ProductState {
  final String error;

  LoadProductListFailure(this.error);
}

class AddProductSuccess extends ProductState {
  final Product response;

  AddProductSuccess(this.response);
}

class AddProductFailure extends ProductState {
  final String error;

  AddProductFailure(this.error);
}

class LoadingProductList extends ProductState {
  LoadingProductList();
}

class LoadingProductDetail extends ProductState {
  LoadingProductDetail();
}

class LoadProductDetailSuccess extends ProductState {
  final Product response;

  LoadProductDetailSuccess(this.response);
}

class LoadProductDetailFailure extends ProductState {
  final String error;

  LoadProductDetailFailure(this.error);
}

class LoadingProductUom extends ProductState {
  LoadingProductUom();
}

class LoadProductUomSuccess extends ProductState {
  final List<Uom> response;

  LoadProductUomSuccess(this.response);
}

class LoadProductUomFailure extends ProductState {
  final String error;

  LoadProductUomFailure(this.error);
}

class GenerateBarcodeSuccess extends ProductState {
  final String barcodeUrl;

  GenerateBarcodeSuccess(this.barcodeUrl);
}

class GenerateBarcodeFailure extends ProductState {
  final String error;

  GenerateBarcodeFailure(this.error);
}

class GeneratingBarcode extends ProductState {}

class DeleteProductSuccess extends ProductState {
  final Product product;

  DeleteProductSuccess(this.product);
}

class DeleteProductFailure extends ProductState {
  final String error;

  DeleteProductFailure(this.error);
}

class DeletingProduct extends ProductState {}
