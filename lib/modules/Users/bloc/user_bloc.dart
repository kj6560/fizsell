import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:fizsell/modules/Users/Dio/user_repository.dart';

import '../../../core/config/config.dart';
import '../../../core/local/hive_constants.dart';
import '../../auth/models/User.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserRepositoryImpl userRepositoryImpl = UserRepositoryImpl();

  UserBloc() : super(UserInitial()) {
    on<LoadUserList>(_loadUserList);
    on<CreateUser>(_createUser);
    on<DeleteUser>(_deleteUser);
  }

  void _loadUserList(LoadUserList event, Emitter<UserState> emit) async {
    emit(LoadingUserList());
    String userString = await authBox.get(HiveKeys.userBox);
    String token = await authBox.get(HiveKeys.accessToken);
    User user = User.fromJson(jsonDecode(userString));
    final response = await userRepositoryImpl.fetchUsersByOrg(
      user.orgId,
      token,
    );
    print(response);
    if (response == null || response.data == null) {
      emit(LoadUserListFailure("No response from server"));
      return;
    }

    final data =
        response.data['data'] is String
            ? jsonDecode(response.data['data'])
            : response.data['data'];
    print(data);
    final List<User> userList = userListFromJson(jsonEncode(data));

    if (response.statusCode == 401) {
      emit(LoadUserListFailure("Login failed."));
      return;
    }
    emit(LoadUserlistSuccess(userList));
  }

  void _createUser(CreateUser event, Emitter<UserState> emit) async {
    emit(CreatingUser());
    String token = await authBox.get(HiveKeys.accessToken);
    final response = await userRepositoryImpl.createUser(
      name: event.name,
      email: event.email,
      password: event.password,
      number: event.number,
      role: event.role,
      isActive: event.isActive,
      profilePicPath: event.profilePicPath,
      token: token,
    );

    if (response == null) {
      emit(CreateUserFailure("Failed to create user"));
      return;
    }

    if (response.statusCode == 422) {
      String errorMessage = response.data['message'] ?? "Validation error";
      emit(CreateUserFailure(errorMessage));
      return;
    }

    if (response.statusCode == 200) {
      emit(CreateUserSuccess("User created successfully"));
    } else {
      String errorMessage = response.data['message'] ?? "Error occurred";
      emit(CreateUserFailure(errorMessage));
    }
  }
  void _deleteUser(DeleteUser event, Emitter<UserState> emit) async {
    emit(DeletingUser());
    String token = await authBox.get(HiveKeys.accessToken);
    int user_id = event.userId;
    final response = await userRepositoryImpl.deleteUser(user_id,token);

    if (response == null) {
      emit(DeleteUserFailure("Failed to delete user"));
      return;
    }

    if (response.statusCode == 422) {
      String errorMessage = response.data['message'] ?? "Validation error";
      emit(DeleteUserFailure(errorMessage));
      return;
    }

    if (response.statusCode == 200) {
      emit(DeleteUserSuccess("User deleted successfully"));
    } else {
      String errorMessage = response.data['message'] ?? "Error occurred";
      emit(DeleteUserFailure(errorMessage));
    }
  }
}
