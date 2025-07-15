import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_curl_logger/dio_curl_logger.dart';

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
      if (!dio.interceptors.any((i) => i is CurlLoggingInterceptor)) {
        dio.interceptors.add(
          CurlLoggingInterceptor(
            showRequestLog: true,
            showResponseLog: true,
          ),
        );
      }
      Response response = await dio.get(
        EndPoints.fetchProducts,
        queryParameters: {
          'org_id': org_id,
          if (id.isNotEmpty) 'product_id': int.parse(id),
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => true,
        ),
      );

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
      List<File> selectedImages,
      ) async {
    try {
      print("selected images: ${selectedImages.length}");

      List<MultipartFile> imageFiles = await Future.wait(
        selectedImages.map((file) async {
          return await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          );
        }),
      );

      FormData formData = FormData.fromMap({
        'org_id': org_id.toString(),
        'name': name,
        'sku': sku,
        'product_mrp': product_mrp.toString(),
        'base_price': base_price.toString(),
        'uom_id': uom_id.toString(),
        'images[]': imageFiles,
      });

      // ✅ Safely log fields
      print("Sending fields:");
      formData.fields.forEach((f) => print("${f.key}: ${f.value}"));

      print("Sending files:");
      formData.files.forEach((f) {
        print("${f.key}: ${f.value.filename}");
      });

      // ✅ Use Dio without printing the FormData itself
      dio.interceptors.clear();
      Response response = await dio.post(
        EndPoints.addProduct,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      return response;
    } catch (e, stacktrace) {
      print('Error in addProducts: $e');
      print(stacktrace);
      return null;
    }
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
