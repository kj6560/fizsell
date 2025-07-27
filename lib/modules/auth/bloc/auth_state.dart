part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {}

class Unauthenticated extends AuthState {}

class LoginInitial extends AuthState {}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final User user;
  final String token;

  LoginSuccess(this.user, this.token);
}

class LoginFailure extends AuthState {
  final String error;

  LoginFailure(this.error);
}

class SubscriptionFailure extends AuthState {
  final User user;

  SubscriptionFailure(this.user);
}
