import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/config/endpoints.dart';

class AppContactRepository {
  final Dio dio = Dio();

  AppContactRepository();

  Future<Response?> fetchContactResponses(int userId, String token) async {
    try {
      Response response = await dio.get(
        EndPoints.fetchContactResponses,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        queryParameters: {
          'user_id': userId,
        },
      );
      return response;
    } catch (e, stacktrace) {
      print(e.toString());
      print(stacktrace);
    }
  }

  Future<Response?> createContactFromApp(
      String name,String email,String message,int user_id, String token) async {
    try {
      var body = {
        'name': name,
        'email': email,
        'message': message,
        'user_id': user_id
      };
      print(jsonEncode(body));
      Response response = await dio.post(
        EndPoints.createContactFromApp,
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
