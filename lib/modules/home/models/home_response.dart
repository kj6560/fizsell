import 'package:dio/dio.dart';

import '../../../core/config/endpoints.dart';

class HomeRepositoryImpl {
  final Dio dio = Dio();

  Future<Response?> fetchKpi(int user_id, String token) async {
    try {
      // var body = {'user_id': user_id};

      Response response = await dio.get(
        EndPoints.fetchKpi,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        //data: jsonEncode(body),
      );
      print(response);
      return response;
    } catch (e, stacktrace) {
      print(e.toString());
      print(stacktrace);
    }
    return null;
  }
}
