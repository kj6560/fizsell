part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class LoadUserList extends UserEvent{}

class CreateUser extends UserEvent {
  final String name;
  final String email;
  final String password;
  final String number;
  final int role;
  final int isActive;
  final String profilePicPath;

  CreateUser({
    required this.name,
    required this.email,
    required this.password,
    required this.number,
    required this.role,
    required this.isActive,
    required this.profilePicPath,
  });
}
class DeleteUser extends UserEvent{
  final int userId;
  DeleteUser({required this.userId});
}