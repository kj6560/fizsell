import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/config/endpoints.dart';

class SettingsRepositoryImpl {
  Dio dio = Dio();

  SettingsRepositoryImpl();

  Future<Response?> fetchCurrencies(String token) async {
    try {

      Response response = await dio.get(
        EndPoints.fetchCurrencies,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print(response.data);
      return response;
    } catch (e, stacktrace) {
      print(e.toString());
      print(stacktrace);
    }
    return null;
  }


  Future<Response?> setCurrency(
      int org_id, String token, int currency_id) async {
    try {
      var payload = {
        "org_id":org_id,
        "currency_id":currency_id
      };
      Response response = await dio.post(
        EndPoints.setCurrency,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
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


}
