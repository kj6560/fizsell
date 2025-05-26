import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/config/config.dart';
import '../../../../core/local/hive_constants.dart';
import '../../../core/config/endpoints.dart';
import '../../../core/routes.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/models/User.dart';
import '../Dio/DioRepo.dart';
import '../models/home_response_model.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeRepositoryImpl homeRepositoryImpl = HomeRepositoryImpl();

  HomeBloc() : super(HomeInitial()) {
    on<HomeLoad>(_loadHome);
  }

  void _loadHome(HomeLoad event, Emitter<HomeState> emit) async {
    try {
      emit(LoadingHome());
      print("loading");
      String userString = await authBox.get(HiveKeys.userBox);
      String token = await authBox.get(HiveKeys.accessToken);
      User user = User.fromJson(jsonDecode(userString));
      final response = await homeRepositoryImpl.fetchKpi(user.id, token);
      print(response);
      if (response == null || response.data == null) {
        emit(LoadFailure(error: "No response from server"));
        return;
      }

      // Ensure data is always a Map<String, dynamic>
      final data =
          response.data['data'] is String
              ? jsonDecode(response.data['data'])
              : response.data['data'];
      final kpiResponse = HomeResponse.fromJson(data);
      print(kpiResponse);
      if (response.statusCode == 401) {
        emit(ForceLogout());
        return;
      }
      if (response.statusCode == 200 && response.data['status'] == 'error') {
        emit(LoadFailure(error: "You Do not have an active subscription"));
        return;
      }
      emit(LoadSuccess(response: kpiResponse));
    } catch (e, stacktrace) {
      print('Exception in bloc: $e');
      print('Stacktrace: $stacktrace');
      emit(LoadFailure(error: "An error occurred."));
    }
    return;
  }
}
