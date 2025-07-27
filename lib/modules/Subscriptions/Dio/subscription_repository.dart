import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_curl_logger/dio_curl_logger.dart';
import 'package:fizsell/core/config/endpoints.dart';

class SubscriptionRepository {
  Dio dio = Dio();

  SubscriptionRepository();

  Future<Response?> fetchSubscriptionList() async {
    try {
      Response response = await dio.get(
        EndPoints.fetchSubscriptionList,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      return response;
    } catch (e, stacktrace) {
      print(e.toString());
      print(stacktrace);
    }
  }

  Future<Response?> fetchSubscriptionDetail(int id) async {
    try {
      var payload = {"subscription_id": id};
      Response response = await dio.get(
        EndPoints.fetchSubscriptionDetail,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: jsonEncode(payload),
      );
      return response;
    } catch (e, stacktrace) {
      print(e.toString());
      print(stacktrace);
    }
  }

  Future<Response?> createSubscriptionOrder(
      int user_id,
      int plan_id,
      double amount,
      ) async {
    try {
      if (!dio.interceptors.any((i) => i is CurlLoggingInterceptor)) {
        dio.interceptors.add(CurlLoggingInterceptor(showRequestLog: true));
      }

      final queryParams = {
        "user_id": user_id,
        "plan_id": plan_id,
        "amount": amount,
      };

      Response response = await dio.post(
        EndPoints.createSubscriptionOrder,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        queryParameters: queryParams, // ✅ use query params here
      );

      return response;
    } catch (e, stacktrace) {
      print(e.toString());
      print(stacktrace);
    }
  }
}
