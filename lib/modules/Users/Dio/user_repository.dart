import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fizsell/core/config/base_url.dart';

import '../../../../core/config/endpoints.dart';

class UserRepositoryImpl {
  final Dio _dio = Dio();

  Future<Response?> fetchUsersByOrg(int orgId, String token) async {

    try {
      var body = {'org_id': orgId};
      Response response = await _dio.get(
        EndPoints.fetchUsersByOrg,
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

  Future<Response?> createUser({
    required String name,
    required String email,
    required String password,
    required String number,
    required int role,
    required int isActive,
    required String profilePicPath,
    required String token,
  }) async {
    try {
      final file = await MultipartFile.fromFile(profilePicPath);

      final formData = FormData.fromMap({
        'name': name,
        'email': email,
        'password': password,
        'number': number,
        'role': role,
        'is_active': isActive,
        'profile_pic': file,
      });

      print({
        'name': name,
        'email': email,
        'password': password,
        'number': number,
        'role': role,
        'is_active': isActive,
        'profile_pic': file.filename,
      });

      return await _dio.post(
        EndPoints.createNewUser,
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        print("Error response data: ${e.response?.data}");
        return e.response;
      } else {
        print("DioException without response: ${e.message}");
      }
    } catch (e) {
      print("Unexpected error: $e");
    }

    return null;
  }
  Future<Response?> deleteUser(int userId, String token) async {

    try {
      var body = {'user_id': userId};
      Response response = await _dio.get(
        EndPoints.deleteUser,
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