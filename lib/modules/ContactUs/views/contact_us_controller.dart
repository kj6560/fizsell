library contact_us_library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fizsell/core/widgets/base_screen.dart';
import 'package:fizsell/core/widgets/base_widget.dart';
import 'package:fizsell/modules/auth/models/User.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/config.dart';
import '../../../core/local/hive_constants.dart';
import '../../../core/routes.dart';
import '../bloc/contact_us_bloc.dart';

part 'contact_us_screen.dart';

class ContactUsController extends StatefulWidget {
  const ContactUsController({super.key});

  @override
  State<ContactUsController> createState() => ContactUsControllerState();
}

class ContactUsControllerState extends State<ContactUsController> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();
  bool hasActiveSubscription = false;
  @override
  Widget build(BuildContext context) {
    return ContactUsScreen(this);
  }

  void submitRequest() {
    String token = authBox.get(HiveKeys.accessToken);
    String userJson = authBox.get(HiveKeys.userBox);
    User user = User.fromJson(jsonDecode(userJson));
    context.read<ContactUsBloc>().add(
      SubmitContactFormEvent(
        name: nameController.text,
        email: emailController.text,
        message: messageController.text,
        userId: user.id,  // Replace with dynamic user ID
        token: token,  // Replace with actual token
      ),
    );
  }
  void changeSubscriptionStatus(bool status) {
    setState(() {
      hasActiveSubscription = status;
    });
  }
}

