import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/config/config.dart';
import '../../../../core/local/hive_constants.dart';
import '../../auth/models/User.dart';
import '../Dio/product_repository.dart';
import '../models/product_uom.dart';
import '../models/products_model.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductRepositoryImpl productRepositoryImpl = ProductRepositoryImpl();

  ProductBloc() : super(ProductInitial()) {
    on<LoadProductList>(_loadProduct);
    on<AddNewProduct>(_addNewProduct);
    on<LoadProductDetail>(_loadProductDetail);
    on<LoadProductUom>(_loadProductUom);
    on<GenerateBarcode>(_generateBarcode);
    on<DeleteProduct>(_deleteProduct);
  }

  void _loadProduct(LoadProductList event, Emitter<ProductState> emit) async {
    try {
      emit(LoadingProductList());
      String userString = await authBox.get(HiveKeys.userBox);
      String token = await authBox.get(HiveKeys.accessToken);
      User user = User.fromJson(jsonDecode(userString));
      print('user org id: ${user.orgId}');
      final response =
          await productRepositoryImpl.fetchProducts(user.orgId, token);
      if (response == null || response.data == null) {
        emit(LoadProductListFailure("No response from server"));
        return;
      }
      print(response);
      // Ensure data is always a Map<String, dynamic>
      final data = response.data['data'] is String
          ? jsonDecode(response.data['data'])
          : response.data['data'];
      print(data);
      final List<Product> products = productFromJson(jsonEncode(data));

      if (response.statusCode == 401) {
        emit(LoadProductListFailure("Login failed."));
        return;
      }
      if (response.statusCode == 202) {
        emit(LoadProductListFailure(response.data['message']));
        return;
      }
      emit(LoadProductSuccess(products));
    } catch (e, stacktrace) {
      print('Exception in bloc: $e');
      print('Stacktrace: $stacktrace');
      emit(LoadProductListFailure("An error occurred."));
    }
    return;
  }

  void _addNewProduct(AddNewProduct event, Emitter<ProductState> emit) async {
    try {
      String userString = await authBox.get(HiveKeys.userBox);
      String token = await authBox.get(HiveKeys.accessToken);
      User user = User.fromJson(jsonDecode(userString));
      int org_id = user.orgId;
      String name = event.name;
      String sku = event.sku;
      double product_mrp = event.price;
      double base_price = event.base_price;
      int uom_id = event.uom_id;
      final response = await productRepositoryImpl.addProducts(
          org_id, token, name, sku, product_mrp, base_price, uom_id,event.selectedImages);
      if (response == null || response.data == null) {
        emit(AddProductFailure("No response from server"));
        return;
      }

      // Ensure data is always a Map<String, dynamic>
      final data = response.data['data'] is String
          ? jsonDecode(response.data['data'])
          : response.data['data'];
      print("created product${data}");
      if (response.statusCode == 401) {
        emit(AddProductFailure("Login failed."));
        return;
      }
      emit(AddProductSuccess());
    } catch (e, stacktrace) {
      print('Exception in bloc: $e');
      print('Stacktrace: $stacktrace');
      emit(AddProductFailure("An error occurred."));
    }
    return;
  }

  void _loadProductDetail(LoadProductDetail event, Emitter<ProductState> emit) async {
    try {
      emit(LoadingProductDetail());
      String userString = await authBox.get(HiveKeys.userBox);
      String token = await authBox.get(HiveKeys.accessToken);
      User user = User.fromJson(jsonDecode(userString));
      String product_id = event.product_id;
      print('user org id: ${user.orgId}');
      final response = await productRepositoryImpl
          .fetchProducts(user.orgId, token, id: product_id.toString());
      if (response == null || response.data == null) {
        emit(LoadProductDetailFailure("No response from server"));
        return;
      }

      // Ensure data is always a Map<String, dynamic>
      final data = response.data['data'] is String
          ? jsonDecode(response.data['data'])
          : response.data['data'];
      print(data);
      final Product product = Product.fromJson(data);

      if (response.statusCode == 401) {
        emit(LoadProductDetailFailure("Login failed."));
        return;
      }
      emit(LoadProductDetailSuccess(product));
    } catch (e, stacktrace) {
      print('Exception in bloc: $e');
      print('Stacktrace: $stacktrace');
      emit(LoadProductDetailFailure("An error occurred."));
    }
    return;
  }

  void _loadProductUom(LoadProductUom event, Emitter<ProductState> emit) async {
    try {
      emit(LoadingProductUom());
      String userString = await authBox.get(HiveKeys.userBox);
      String token = await authBox.get(HiveKeys.accessToken);
      User user = User.fromJson(jsonDecode(userString));
      print('user org id: ${user.orgId}');
      final response =
          await productRepositoryImpl.fetchProductUom(user.orgId, token);
      if (response == null || response.data == null) {
        emit(LoadProductUomFailure("No response from server"));
        return;
      }

      // Ensure data is always a Map<String, dynamic>
      final data = response.data['data'] is String
          ? jsonDecode(response.data['data'])
          : response.data['data'];
      print(data);
      List<Uom> productUoms = uomFromJson(jsonEncode(data));
      if (response.statusCode == 401) {
        emit(LoadProductUomFailure("Login failed."));
        return;
      }
      productUoms = productUoms.toSet().toList();
      emit(LoadProductUomSuccess(productUoms));
    } catch (e, stacktrace) {
      print('Exception in bloc: $e');
      print('Stacktrace: $stacktrace');
      emit(LoadProductUomFailure("An error occurred."));
    }
    return;
  }

  void _generateBarcode(GenerateBarcode event, Emitter<ProductState> emit) async {
    try {
      String token = await authBox.get(HiveKeys.accessToken);
      String barcodeValue = event.barcodeValue;

      final response =
          await productRepositoryImpl.generateBarcode(token, barcodeValue);
      if (response == null || response.data == null) {
        emit(GenerateBarcodeFailure("No response from server"));
        return;
      }

      // Ensure data is always a Map<String, dynamic>
      final data = response.data['data'] is String
          ? jsonDecode(response.data['data'])
          : response.data['data'];
      print(data['barcode_url']);

      if (response.statusCode == 401) {
        emit(GenerateBarcodeFailure("Login failed."));
        return;
      }
      emit(GenerateBarcodeSuccess(data['barcode_url']));
    } catch (e, stacktrace) {
      print('Exception in bloc: $e');
      print('Stacktrace: $stacktrace');
      emit(GenerateBarcodeFailure("An error occurred."));
    }
    return;
  }

  void _deleteProduct(DeleteProduct event, Emitter<ProductState> emit) async {
    try {
      emit(DeletingProduct());
      String token = await authBox.get(HiveKeys.accessToken);
      int id = event.id;

      final response = await productRepositoryImpl.deleteProduct(token, id);
      if (response == null || response.data == null) {
        emit(DeleteProductFailure("No response from server"));
        return;
      }

      // Ensure data is always a Map<String, dynamic>
      final data = response.data['data'] is String
          ? jsonDecode(response.data['data'])
          : response.data['data'];
      if (response.statusCode == 401) {
        emit(DeleteProductFailure("Login failed."));
        return;
      }
      emit(DeleteProductSuccess());
    } catch (e, stacktrace) {
      print('Exception in bloc: $e');
      print('Stacktrace: $stacktrace');
      emit(DeleteProductFailure("An error occurred."));
    }
    return;
  }
}
