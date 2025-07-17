import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/config/endpoints.dart';

class CustomerRepositoryImpl {
  final Dio dio = Dio();

  CustomerRepositoryImpl();

  Future<Response?> fetchCustomers(int org_id, String token,
      {int customerId = 0}) async {
    try {
      var body = {'org_id': org_id};

      if (customerId != 0) {
        body['customer_id'] = customerId;
      }
      print("payload: ${jsonEncode(body)}");
      Response response = await dio.get(
        EndPoints.fetchCustomers,
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

  Future<Response?> newCustomer(
      int org_id, int user_id, String payload, String token) async {
    try {
      var body = {
        'org_id': org_id,
        'order': jsonDecode(payload),
        'created_by': user_id
      };
      print(jsonEncode(body));
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

  Future<Response?> createCustomers(
      int org_id,
      String customer_name,
      String customer_address,
      String customer_phone_number,
      File? customer_image, // make it nullable if optional
      int customer_active,
      int customer_type,
      String token,
      ) async {
    print("customer type: $customer_type");

    try {
      FormData formData = FormData();

      formData.fields.addAll([
        MapEntry('org_id', org_id.toString()),
        MapEntry('customer_name', customer_name),
        MapEntry('customer_address', customer_address),
        MapEntry('customer_phone_number', customer_phone_number),
        MapEntry('customer_active', customer_active.toString()),
        MapEntry('customer_type', customer_type.toString()),
      ]);

      if (customer_image != null && customer_image.path.isNotEmpty) {
        formData.files.add(MapEntry(
          'customer_image',
          await MultipartFile.fromFile(
            customer_image.path,
            filename: customer_image.path.split('/').last,
          ),
        ));
      }

      Response response = await Dio().post(
        EndPoints.newCustomer,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: formData,

      );

      return response;
    } catch (e) {
      if (e is DioException) {
        print("Error Response: ${e.response?.data}");
      }
      print("Error: $e");
      return null;
    }
  }


  Future<Response?> updateCustomers(
    int customer_id,
    int org_id,
    String customer_name,
    String customer_address,
    String customer_phone_number,
    File? customer_image,
    int customer_active,
    int customer_type,
    String token,
  ) async {
    try {
      print({
        'org_id': org_id,
        'customer_id': customer_id,
        'customer_name': customer_name,
        'customer_address': customer_address,
        'customer_phone_number': customer_phone_number,
        'customer_type':customer_type,
        'customer_active': customer_active,
      });
      FormData formData = FormData.fromMap({
        'org_id': org_id,
        'customer_id': customer_id,
        'customer_name': customer_name,
        'customer_address': customer_address,
        'customer_phone_number': customer_phone_number,
        'customer_type':customer_type,
        'customer_active': customer_active,
      });
      if (customer_image != null) {
        formData.files.add(
          MapEntry(
            'customer_image',
            await MultipartFile.fromFile(
              customer_image.path,
              filename: customer_image.path.split('/').last,
            ),
          ),
        );
      }
      Response response = await Dio().post(
        EndPoints.newCustomer,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => true,
        ),
        data: formData,
      );
      print("status code: ${response.statusCode}");
      return response;
    } catch (e) {
      if (e is DioException) {
        print(
            "Error Response: ${e.response?.data}"); // Print Laravel validation error response
      }
      print("Error: $e");
    }
  }
}
