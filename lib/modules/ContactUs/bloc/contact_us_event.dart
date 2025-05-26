part of 'contact_us_bloc.dart';

@immutable
abstract class ContactUsEvent {}

class SubmitContactFormEvent extends ContactUsEvent {
  final String name;
  final String email;
  final String message;
  final int userId;
  final String token;

  SubmitContactFormEvent({
    required this.name,
    required this.email,
    required this.message,
    required this.userId,
    required this.token,
  });
}

class FetchContactResponsesEvent extends ContactUsEvent {
  final int userId;
  final String token;

  FetchContactResponsesEvent({
    required this.userId,
    required this.token,
  });
}