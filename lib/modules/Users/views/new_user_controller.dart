library new_user_library;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/widgets/base_screen.dart';
import '../../../core/widgets/base_widget.dart';
import '../bloc/user_bloc.dart';

part 'new_user.dart';

class NewUserController extends StatefulWidget {
  const NewUserController({super.key});

  @override
  State<NewUserController> createState() => NewUserControllerState();
}

class NewUserControllerState extends State<NewUserController> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedRole;
  String? selectedStatus;
  File? imageFile;

  final List<String> roles = ['Admin', 'Manager', 'Asst. Manager', 'User'];
  final List<String> statusOptions = ['Active', 'Inactive'];

  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  void handleSubmit() {
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String phone = phoneController.text.trim();
    final String password = passwordController.text.trim();
    var role = 5;
    switch (selectedRole) {
      case "Admin":
        role = 2;
        break;
      case "Manager":
        role = 3;
      case "Asst. Manager":
        role = 4;
      case "User":
        role = 5;
      default:
        role = 5;
    }
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        selectedRole == null ||
        selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    context.read<UserBloc>().add(CreateUser(
      name: name,
      email: email,
      password: password,
      number: phone,
      role: role,
      isActive: selectedStatus == "Active" ? 1 : 0,
      profilePicPath: imageFile!.path,
    ));

    // Implement your API call or form submission logic here.
  }
  void clearFormFields() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    selectedRole = null;
    selectedStatus = null;
    imageFile = null;

    setState(() {});
  }
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NewUser(this);
  }
}
