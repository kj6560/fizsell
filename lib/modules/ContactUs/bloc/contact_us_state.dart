part of 'contact_us_bloc.dart';

@immutable
abstract class ContactUsState {}

class ContactUsInitial extends ContactUsState {}

class ContactUsLoading extends ContactUsState {}

class ContactUsSubmitting extends ContactUsState {}

class FetchingContactResponses extends ContactUsState {}

class ContactUsSubmissionSuccess extends ContactUsState {
  final String message;

  ContactUsSubmissionSuccess({required this.message});
}

class ContactUsSubmissionFailure extends ContactUsState {
  final String error;

  ContactUsSubmissionFailure({required this.error});
}

class ContactUsResponsesLoaded extends ContactUsState {
  final List<AppContact> contacts;

  ContactUsResponsesLoaded({required this.contacts});
}

class ContactUsResponsesFailure extends ContactUsState {
  final String error;

  ContactUsResponsesFailure({required this.error});
}
