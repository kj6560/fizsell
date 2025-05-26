

import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';

import '../Dio/DioRepo.dart';
import '../models/User.dart';
import '../models/login_response.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepositoryImpl authRepositoryImpl = AuthRepositoryImpl();
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>((event, emit) => emit(Authenticated()));
    on<LogoutEvent>((event, emit) => emit(Unauthenticated()));
    on<LoginButtonPressed>(_loginToServer);
    on<LoginButtonClicked>(_loginClicked);
    on<LoginReset>((event, emit) {
      emit(LoginInitial());
    });
  }
  _loginClicked(LoginButtonClicked event, Emitter<AuthState> emit) {
    emit(LoginLoading());
    return;
  }

  Future<void> _loginToServer(LoginButtonPressed event, Emitter<AuthState> emit) async {
    emit(LoginLoading()); // ✅ Emit loading state once

    try {
      print("📩 Logging in: ${event.email}");
      var deviceId = await getDeviceId();
      final response =
      await authRepositoryImpl.login(event.email, event.password,deviceId);

      if (response == null || response.data == null) {
        print("a");
        emit(LoginFailure("No response from server"));
        return;
      }

      final data =
      response.data is String ? jsonDecode(response.data) : response.data;
      final loginResponse = Response.fromJson(data);
      print("login response: ${loginResponse.data['user']}");
      if (loginResponse.statusCode == 200 && loginResponse.data != null) {
        final user = User.fromJson(loginResponse.data['user']);
        emit(LoginSuccess(user, loginResponse.data['token']));
      } else {
        // 🔥 Handle all error messages in one place
        final message = loginResponse.message ?? "Login failed.";
        print("b");
        emit(LoginFailure(message));
      }
    } catch (e, stacktrace) {
      print('❌ Exception in login bloc: $e');
      print('📌 Stacktrace: $stacktrace');
      print("c");
      emit(LoginFailure("An unexpected error occurred. Please try again."));
    }
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