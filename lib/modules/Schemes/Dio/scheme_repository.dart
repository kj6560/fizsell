import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/config/endpoints.dart';

class SchemeRepositoryImpl {
  Dio dio = Dio();

  SchemeRepositoryImpl();

  Future<Response?> allSchemes(int org_id, String token) async {
    try {
      var body = {'org_id': org_id};

      Response response = await dio.get(
        EndPoints.allSchemes,
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

  Future<Response?> fetchSchemes(int org_id, String token, {int id = 0}) async {
    try {
      var body = {};
      if (id != 0) {
        body['id'] = id;
      }
      print("hitting: ${EndPoints.fetchSchemes}");
      Response response = await dio.get(
        EndPoints.fetchSchemes,
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

  Future<Response?> createOrUpdateScheme(
      int org_id, String token, Map<String, dynamic> payload) async {
    try {
      Response response = await dio.post(
        EndPoints.updateScheme,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: jsonEncode(payload),
      );
      print(response.toString());
      return response;
    } catch (e, stacktrace) {
      print(e.toString());
      print(stacktrace);
    }
  }

  Future<Response?> deleteScheme(
      int org_id, String token, int scheme_id) async {
    try {
      var payload = {'id': scheme_id};
      Response response = await dio.post(
        EndPoints.deleteScheme,
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

  Future<Response?> fetchProducts(int org_id, String token,
      {int id = 0}) async {
    try {
      var body = {'org_id': org_id};
      if (id != 0) {
        body['product_id'] = id;
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
      return response;
    } catch (e, stacktrace) {
      print(e.toString());
      print(stacktrace);
    }
  }
}
