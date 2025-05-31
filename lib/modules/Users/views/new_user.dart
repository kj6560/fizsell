part of new_user_library;

class NewUser extends WidgetView<NewUser, NewUserControllerState> {
  const NewUser(super.controllerState, {super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Create New User",
      body: BlocConsumer<UserBloc, UserState>(
        builder: (context, state) {
          if (state is CreatingUser) {
            return Column(
              children: [
                Center(child: CircularProgressIndicator(color: Colors.teal)),
              ],
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    controllerState.nameController,
                    "Name",
                    TextInputType.text,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controllerState.emailController,
                    "Email",
                    TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controllerState.phoneController,
                    "Phone Number",
                    TextInputType.phone,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controllerState.passwordController,
                    "Password",
                    TextInputType.visiblePassword,
                    isPassword: true,
                  ),
                  SizedBox(height: 16),
                  _buildDropdown(
                    "Role",
                    controllerState.selectedRole,
                    controllerState.roles,
                    (value) {
                      controllerState.setState(
                        () => controllerState.selectedRole = value,
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  _buildDropdown(
                    "Status",
                    controllerState.selectedStatus,
                    controllerState.statusOptions,
                    (value) {
                      controllerState.setState(
                        () => controllerState.selectedStatus = value,
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  _buildImagePicker(),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: controllerState.handleSubmit,
                    child: Text("Create User"),
                  ),
                ],
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is CreateUserSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            controllerState.clearFormFields();
          } else if (state is CreateUserFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    TextInputType type, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.grey,
          ), // Change this to your desired color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFB5A13F),
          ), // Color when focused
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? selectedValue,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue,
          items:
              items
                  .map(
                    (String value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.grey,
              ), // Change this to your desired color
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFB5A13F),
              ), // Color when focused
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Profile Picture",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: controllerState.pickImage,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                controllerState.imageFile != null
                    ? Image.file(controllerState.imageFile!, fit: BoxFit.cover)
                    : Icon(Icons.camera_alt, size: 40, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
