import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/config/endpoints.dart';

part 'organization_event.dart';
part 'organization_state.dart';

class OrganizationBloc extends Bloc<OrganizationEvent, OrganizationState> {
  OrganizationBloc() : super(OrganizationInitial()) {
    on<CreateOrganizationRequested>(_onCreate);
  }

  Future<void> _onCreate(
      CreateOrganizationRequested event, Emitter emit) async {
    emit(OrganizationLoading());
    try {
      final response = await Dio().get(
        EndPoints.createOrganization,
        data: jsonEncode(event.orgData),
      );
      if (response.data['statusCode'] == 200) {
        emit(OrganizationSuccess(response.data['message']));
      } else {
        emit(OrganizationFailure(response.data['message']));
      }
    } catch (e) {
      print(e.toString());
      emit(OrganizationFailure(
          "Failed to create organization. Please try again."));
    }
  }
}
