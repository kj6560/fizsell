import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../core/config/endpoints.dart';

class AuthRepositoryImpl {
  final Dio dio = Dio();

  Future<Response?> login(String email, String password, String deviceId) async {
    var body = {'email': email, 'password': password,'device_id':deviceId};
    print(jsonEncode(body));
    Response response = await dio.get(
      EndPoints.login,
      options: Options(contentType: "application/json"),
      data: jsonEncode(body),
    );
    print('✅ Status: ${response.statusCode}');
    print('✅ Response Data: ${response.data}');
    return response;
  }

  Future<void> register(String username, String password, String email) async {
    // Implement your register logic with Dio
    try {
      final response = await dio.post(
        'https://example.com/api/register',
        data: {
          'username': username,
          'password': password,
          'email': email,
        },
      );
      // Handle response
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  Future<void> forgotPassword(String email) async {
    // Implement your forgot password logic with Dio
    try {
      final response = await dio.post(
        'https://example.com/api/forgot_password',
        data: {
          'email': email,
        },
      );
      // Handle response
    } catch (e) {
      throw Exception('Failed to send forgot password request: $e');
    }
  }
}
