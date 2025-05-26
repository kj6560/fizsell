library users_list_library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fizsell/core/widgets/base_screen.dart';
import 'package:fizsell/core/widgets/base_widget.dart';
import 'package:fizsell/modules/Organization/bloc/organization_bloc.dart';
import 'package:fizsell/modules/Users/bloc/user_bloc.dart';
import 'package:fizsell/modules/auth/models/User.dart';

import '../../../core/config/config.dart';
import '../../../core/local/hive_constants.dart';

part 'users_list.dart';

class UsersListController extends StatefulWidget {
  const UsersListController({super.key});

  @override
  State<UsersListController> createState() => UsersListControllerState();
}

class UsersListControllerState extends State<UsersListController> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<UserBloc>().add(LoadUserList());
  }

  @override
  Widget build(BuildContext context) {
    return UsersList(this);
  }

  Future<bool> checkRoleAndAddUser() async{
    String userString = await authBox.get(HiveKeys.userBox);
    User user = userFromJson(userString);
    if(user.role == 1 || user.role == 2 || user.role == 3){
      Navigator.pushNamed(context, '/new_user');
      return true;
    }else{
      return false;
    }
  }
  Future<void> showDeleteConfirmationDialog(int userId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this user?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                deleteUser(userId);
              },
              child: const Text("Delete"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }

  void deleteUser(int userId) {
    context.read<UserBloc>().add(DeleteUser(userId: userId));
  }

}
