import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

import '../Dio/app_contact_repository.dart';
import '../models/AppContact.dart';

part 'contact_us_event.dart';
part 'contact_us_state.dart';

class ContactUsBloc extends Bloc<ContactUsEvent, ContactUsState> {
  final AppContactRepository repository = AppContactRepository();

  ContactUsBloc() : super(ContactUsInitial()) {
    on<SubmitContactFormEvent>(_onSubmitContactForm);
    on<FetchContactResponsesEvent>(_onFetchContactResponses);
  }

  Future<void> _onSubmitContactForm(
      SubmitContactFormEvent event, Emitter<ContactUsState> emit) async {
    emit(ContactUsSubmitting());

    try {
      final response = await repository.createContactFromApp(
        event.name,
        event.email,
        event.message,
        event.userId,
        event.token,
      );

      if (response != null && response.statusCode == 200) {
        emit(ContactUsSubmissionSuccess(message: response.data['message']));
      } else {
        emit(ContactUsSubmissionFailure(error: 'Failed to submit contact form.'));
      }
    } catch (e) {
      emit(ContactUsSubmissionFailure(error: e.toString()));
    }
  }

  Future<void> _onFetchContactResponses(
      FetchContactResponsesEvent event, Emitter<ContactUsState> emit) async {
    emit(FetchingContactResponses());

    try {
      final response = await repository.fetchContactResponses(
        event.userId,
        event.token,
      );

      if (response != null && response.statusCode == 200) {
        var Data = response.data;
        print(Data);
        final contacts = appContactFromJson(jsonEncode(Data['data']));
        emit(ContactUsResponsesLoaded(contacts: contacts));
      } else {
        emit(ContactUsResponsesFailure(error: 'Failed to fetch contact responses.'));
      }
    } catch (e) {
      emit(ContactUsResponsesFailure(error: e.toString()));
    }
  }
}