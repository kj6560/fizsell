part of users_list_library;

class UsersList extends WidgetView<UsersList, UsersListControllerState> {
  const UsersList(super.controllerState, {super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "All Users",
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is DeleteUserSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is DeleteUserFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is LoadingUserList) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            );
          } else if (state is LoadUserlistSuccess) {
            if (state.userList.isNotEmpty) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.userList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final user = state.userList[index];
                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          "${baseUrl}/storage/${user.profilePic ?? ''}",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.account_circle, size: 50),
                        ),
                      ),
                      title: Text(
                        user.name ?? "No Name",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(user.email ?? "No Email"),
                          Text(user.number ?? "No Number"),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          controllerState.showDeleteConfirmationDialog(user.id);
                        },
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text("No active users found."));
            }
          } else if (state is LoadUserListFailure) {
            return Center(child: Text(state.error));
          }
          return const Center(child: Text("No users found."));
        },
      ),
      fabIcon: Icons.add,
      onFabPressed: () async {
        bool hasRole = await controllerState.checkRoleAndAddUser();
        if (!hasRole) {
          _showRoleDialog(context);
        }
      },
    );
  }

  Future<void> _showRoleDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New User"),
          content: const Text(
            "You do not have sufficient permission to perform this task. Please contact your administrator.",
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
