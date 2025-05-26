part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class LoadingUserList extends UserState {}

final class CreatingUser extends UserState {}

final class CreateUserFailure extends UserState {
  final String error;

  CreateUserFailure(this.error);
}

final class CreateUserSuccess extends UserState {
  final String message;

  CreateUserSuccess(this.message);
}

final class LoadUserlistSuccess extends UserState {
  final List<User> userList;

  LoadUserlistSuccess(this.userList);
}

final class LoadUserListFailure extends UserState {
  final String error;

  LoadUserListFailure(this.error);
}

final class DeleteUserSuccess extends UserState{
  final String message;
  DeleteUserSuccess(this.message);
}

final class DeleteUserFailure extends UserState{
  final String error;
  DeleteUserFailure(this.error);
}

final class DeletingUser extends UserState{}