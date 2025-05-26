import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';

import '../../../core/config/endpoints.dart';

class HomeRepositoryImpl {
  final Dio dio = Dio(
    BaseOptions(
      validateStatus: (status) {
        // Allow all responses (even 401) to be handled manually
        return status != null && status < 500;
      },
    ),
  );

  Future<Response?> fetchKpi(int user_id, String token) async {
    try {

      var device_id = await getDeviceId();
      var body = {'device_id': device_id};
      Response response = await dio.get(
        EndPoints.fetchKpi,
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
  Future<String> getDeviceId() async {

    String deviceId;
    try {
      final _mobileDeviceIdentifierPlugin = MobileDeviceIdentifier();
      deviceId = await _mobileDeviceIdentifierPlugin.getDeviceId() ??
          'Unknown platform version';
    } on PlatformException {
      deviceId = 'Failed to get platform version.';
    }
    return deviceId;
  }
}
