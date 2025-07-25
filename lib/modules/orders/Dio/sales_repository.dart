import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/config/endpoints.dart';
import 'package:dio_curl_logger/dio_curl_logger.dart';
class SaleRepositoryImpl {
  final Dio dio = Dio();

  SaleRepositoryImpl();

  Future<Response?> fetchOrder(int org_id, String token, {int orderId = 0}) async {
    try {
      // Prepare query parameters
      Map<String, dynamic> queryParams = {
        'org_id': org_id,
      };

      if (orderId != 0) {
        queryParams['order_id'] = orderId;
      }

      // Add interceptor only once (optional, depends on lifecycle)
      if (!dio.interceptors.any((i) => i is CurlLoggingInterceptor)) {
        dio.interceptors.add(
          CurlLoggingInterceptor(
            showRequestLog: true,
            showResponseLog: true,
          ),
        );
      }

      // Perform GET request with query parameters
      Response response = await dio.get(
        EndPoints.fetchSales,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        queryParameters: queryParams,
      );

      return response;
    } catch (e, stacktrace) {
      print("❌ Exception: $e");
      print(stacktrace);
      return null;
    }
  }


  Future<Response?> newOrder(int org_id, int user_id, String payload,
      int payment_method, int customer_id, String token) async {
    try {
      var body = {
        'org_id': org_id,
        'order': jsonDecode(payload),
        'created_by': user_id,
        'payment_mode': payment_method,
        'customer_id': customer_id
      };
      if (!dio.interceptors.any((i) => i is CurlLoggingInterceptor)) {
        dio.interceptors.add(
          CurlLoggingInterceptor(
            showRequestLog: true,
            showResponseLog: true,
          ),
        );
      }
      Response response = await dio.post(
        EndPoints.newSales,
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
  }

  Future<Response?> fetchProducts(int org_id, String token,
      {String product_sku = ""}) async {
    try {
      Map<String, dynamic> queryParams = {'org_id': org_id};

      if (product_sku.isNotEmpty) {
        queryParams['product_sku'] = product_sku;
      }

      Response response = await dio.get(
        EndPoints.fetchProducts,
        queryParameters: queryParams, // Use query parameters instead of data
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response;
    } catch (e, stacktrace) {
      print("Error fetching products: $e");
      print(stacktrace);
      return null; // Return null on failure
    }
  }
}
