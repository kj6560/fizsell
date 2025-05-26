part of 'auth_bloc.dart';

abstract class AuthEvent {}
class LoginEvent extends AuthEvent {}
class LogoutEvent extends AuthEvent {}
class LoginButtonPressed extends AuthEvent {
  final String email;
  final String password;

  LoginButtonPressed({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class LoginButtonClicked extends AuthEvent {}

class LoginReset extends AuthEvent {}