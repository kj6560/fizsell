import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/config/endpoints.dart';

class InventoryRepositoryImpl {
  final Dio dio = Dio();

  InventoryRepositoryImpl();

  Future<Response?> fetchInventory(int org_id, String token,
      {int id = 0}) async {
    try {
      var body = {'org_id': org_id};
      if (id != 0) {
        body['inventory_id'] = id;
      }
      print("payload: ${jsonEncode(body)}");
      Response response = await dio.get(
        EndPoints.fetchInventory,
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

  Future<Response?> addInventory(
      int org_id, String sku, double quantity, String token) async {
    try {
      var body = {
        "org_id": org_id,
        "sku": sku,
        "quantity": quantity,
        "transaction_type": "purchase"
      };
      Response response = await dio.post(
        EndPoints.updateInventory,
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
