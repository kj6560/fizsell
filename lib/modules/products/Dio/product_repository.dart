import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/config/endpoints.dart';

class ProductRepositoryImpl {
  Dio dio = Dio();

  ProductRepositoryImpl();

  Future<Response?> fetchProducts(int org_id, String token,
      {String id = ""}) async {
    try {
      var body = {'org_id': org_id};
      if (id.isNotEmpty) {
        body['product_id'] = int.parse(id);
      }
      Response response = await dio.get(
        EndPoints.fetchProducts,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: jsonEncode(body),
      );
      print(response.data);
      return response;
    } catch (e, stacktrace) {
      print(e.toString());
      print(stacktrace);
    }
    return null;
  }

  Future<Response?> fetchProductUom(int org_id, String token) async {
    try {
      var body = {'org_id': org_id};

      Response response = await dio.get(
        EndPoints.fetchProductUom,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: jsonEncode(body),
      );
      return response;
    } catch (e, stacktrace) {
      print(e.toString());
      print(stacktrace);
    }
    return null;
  }

  Future<Response?> addProducts(
      int org_id,
      String token,
      String name,
      String sku,
      double product_mrp,
      double base_price,
      int uom_id,
      List<File> selectedImages,  // <-- Add this parameter for images
      ) async {
    try {
      print("selected images: ${selectedImages.length}");
      // Create FormData instead of JSON
      FormData formData = FormData.fromMap({
        'org_id': org_id,
        'name': name,
        'sku': sku,
        'product_mrp': product_mrp,
        'base_price': base_price,
        'uom_id': uom_id,
      });

      // Add images to formData
      for (int i = 0; i < selectedImages.length; i++) {
        formData.files.add(MapEntry(
          'images[]', // Or 'image_path' depending on your backend
          await MultipartFile.fromFile(
            selectedImages[i].path,
            filename: selectedImages[i].path.split('/').last,
          ),
        ));
      }

      // Send request
      Response response = await dio.post(
        EndPoints.addProduct,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data', // important for file uploads
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response;
    } catch (e, stacktrace) {
      print('Error in addProducts: $e');
      print(stacktrace);
    }
    return null;
  }


  Future<Response?> generateBarcode(String token, String barcodeValue) async {
    try {
      var body = {'barcode_value': barcodeValue};
      print(body);
      Response response = await dio.get(
        EndPoints.generateBarcode,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: jsonEncode(body),
      );
      return response;
    } catch (e, stacktrace) {
      print(e.toString());
      print(stacktrace);
    }
    return null;
  }

  Future<Response?> deleteProduct(String token, int id) async {
    try {
      var body = {'id': id};
      Response response = await dio.get(
        EndPoints.deleteProduct,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: jsonEncode(body),
      );
      return response;
    } catch (e, stacktrace) {
      print(e.toString());
      print(stacktrace);
    }
    return null;
  }
}
