import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/config/config.dart';
import '../../../../core/local/hive_constants.dart';
import '../../auth/models/User.dart';
import '../../products/models/products_model.dart';
import '../Dio/scheme_repository.dart';
import '../models/scheme_model.dart';

part 'scheme_event.dart';
part 'scheme_state.dart';

class SchemeBloc extends Bloc<SchemeEvent, SchemeState> {
  SchemeRepositoryImpl schemeRepositoryImpl = SchemeRepositoryImpl();

  SchemeBloc() : super(SchemeInitial()) {
    on<LoadSchemeList>(_loadScheme);
    on<LoadSchemeDetails>(_loadSchemeDetails);
    on<DeleteScheme>(_deleteScheme);
    on<LoadProductList>(_loadProductList);
    on<CreateNewScheme>(_createNewScheme);
  }

  void _loadScheme(LoadSchemeList event, Emitter<SchemeState> emit) async {
    try {
      emit(LoadingSchemeList());
      String userString = await authBox.get(HiveKeys.userBox);
      String token = await authBox.get(HiveKeys.accessToken);
      User user = User.fromJson(jsonDecode(userString));
      print('user org id: ${user.orgId}');
      final response =
          await schemeRepositoryImpl.allSchemes(user.orgId!, token);
      if (response == null || response.data == null) {
        emit(LoadSchemeListFailure("No response from server"));
        return;
      }

      // Ensure data is always a Map<String, dynamic>
      final data = response.data['data'] is String
          ? jsonDecode(response.data['data'])
          : response.data['data'];
      print(data);
      final List<Scheme> schemeList = schemeFromJson(jsonEncode(data));

      if (response.statusCode == 401) {
        emit(LoadSchemeListFailure("Login failed."));
        return;
      }
      emit(LoadSchemeListSuccess(schemeList));
    } catch (e, stacktrace) {
      print('Exception in bloc: $e');
      print('Stacktrace: $stacktrace');
      emit(LoadSchemeListFailure("An error occurred."));
    }
    return;
  }

  void _loadSchemeDetails(
      LoadSchemeDetails event, Emitter<SchemeState> emit) async {
    try {
      emit(LoadingSchemeDetails());
      String userString = await authBox.get(HiveKeys.userBox);
      String token = await authBox.get(HiveKeys.accessToken);
      User user = User.fromJson(jsonDecode(userString));
      print('user org id: ${user.orgId}');
      int id = event.scheme_id;
      final response =
          await schemeRepositoryImpl.fetchSchemes(user.orgId!, token, id: id);
      if (response == null || response.data == null) {
        emit(LoadSchemeDetailsFailure("No response from server"));
        return;
      }

      // Ensure data is always a Map<String, dynamic>
      final data = response.data['data'] is String
          ? jsonDecode(response.data['data'])
          : response.data['data'];

      final Scheme schemeList = Scheme.fromJson(data);
      print(data.toString());
      if (response.statusCode == 401) {
        emit(LoadSchemeDetailsFailure("Login failed."));
        return;
      }
      emit(LoadSchemeDetailsSuccess(schemeList));
    } catch (e, stacktrace) {
      print('Exception in bloc: $e');
      print('Stacktrace: $stacktrace');
      emit(LoadSchemeDetailsFailure("An error occurred."));
    }
    return;
  }

  void _deleteScheme(DeleteScheme event, Emitter<SchemeState> emit) async {
    try {
      emit(DeletingScheme());
      String userString = await authBox.get(HiveKeys.userBox);
      String token = await authBox.get(HiveKeys.accessToken);
      User user = User.fromJson(jsonDecode(userString));
      print('user org id: ${user.orgId}');
      int id = event.scheme_id;
      final response =
          await schemeRepositoryImpl.deleteScheme(user.orgId!, token, id);
      if (response == null || response.data == null) {
        emit(LoadSchemeDetailsFailure("No response from server"));
        return;
      }

      // Ensure data is always a Map<String, dynamic>
      final data = response.data['statusCode'];

      if (data == 200) {
        print("deleted");
      }
      if (response.statusCode == 401) {
        emit(DeleteSchemeFailure("Login failed."));
        return;
      }
      emit(DeleteSchemeSuccess());
    } catch (e, stacktrace) {
      print('Exception in bloc: $e');
      print('Stacktrace: $stacktrace');
      emit(DeleteSchemeFailure("An error occurred."));
    }
    return;
  }

  void _loadProductList(
      LoadProductList event, Emitter<SchemeState> emit) async {
    try {
      emit(LoadingProductList());
      String userString = await authBox.get(HiveKeys.userBox);
      String token = await authBox.get(HiveKeys.accessToken);
      User user = User.fromJson(jsonDecode(userString));
      print('user org id: ${user.orgId}');
      final response =
          await schemeRepositoryImpl.fetchProducts(user.orgId!, token);
      if (response == null || response.data == null) {
        emit(LoadProductListFailure("No response from server"));
        return;
      }

      // Ensure data is always a Map<String, dynamic>
      final data = response.data['data'] is String
          ? jsonDecode(response.data['data'])
          : response.data['data'];
      print(data);
      final List<Product> products = productFromJson(jsonEncode(data));

      if (response.statusCode == 401) {
        emit(LoadProductListFailure("Login failed."));
        return;
      }
      emit(LoadProductSuccess(products));
    } catch (e, stacktrace) {
      print('Exception in bloc: $e');
      print('Stacktrace: $stacktrace');
      emit(LoadProductListFailure("An error occurred."));
    }
    return;
  }

  void _createNewScheme(
      CreateNewScheme event, Emitter<SchemeState> emit) async {
    try {
      Map<String, dynamic> payload = event.payload;
      emit(CreatingNewScheme());

      String userString = await authBox.get(HiveKeys.userBox);
      String token = await authBox.get(HiveKeys.accessToken);
      User user = User.fromJson(jsonDecode(userString));
      print('User org ID: ${user.orgId}');

      // Call the repository to create or update the scheme
      final response = await schemeRepositoryImpl.createOrUpdateScheme(
          user.orgId!, token, payload);

      // Print the entire response object (for full HTTP info)
      print('Response: $response');

      // Check for null response or missing data
      if (response == null || response.data == null) {
        print("Response is null or contains no data.");
        emit(SchemeCreateFailure("No response from server"));
        return;
      }

      // Print exact data from the server response
      print('Response data: ${response.data}');

      // Ensure that data is always treated as a Map<String, dynamic>
      final data = response.data['data'] is String
          ? jsonDecode(response.data['data'])
          : response.data['data'];

      // Print parsed `data` for verification
      print('Parsed data: $data');

      // Deserialize data into a Scheme object
      final Scheme newScheme = Scheme.fromJson(data);

      // Handle different status codes (e.g., 401)
      if (response.statusCode == 401) {
        print('Unauthorized: 401');
        emit(SchemeCreateFailure("Login failed."));
        return;
      }

      emit(SchemeCreateSuccess());
    } catch (e, stacktrace) {
      // Print exception and stacktrace for debugging errors
      print('Exception in bloc: $e');
      print('Stacktrace: $stacktrace');
      emit(SchemeCreateFailure("An error occurred."));
    }
    return;
  }
}
