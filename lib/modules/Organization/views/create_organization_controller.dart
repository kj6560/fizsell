library create_organization_library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/config.dart';
import '../../../../core/local/hive_constants.dart';
import '../../../core/widgets/base_widget.dart';
import '../../auth/models/User.dart';
import '../bloc/organization_bloc.dart';

part 'create_organization_screen.dart';

class CreateOrganizationController extends StatefulWidget {
  const CreateOrganizationController({super.key});

  @override
  State<CreateOrganizationController> createState() =>
      CreateOrganizationControllerState();
}

class CreateOrganizationControllerState
    extends State<CreateOrganizationController> {
  String name = "";
  String email = "";
  final _formKey = GlobalKey<FormState>();
  final _orgNameController = TextEditingController();
  final _orgEmailController = TextEditingController();
  final _orgNumberController = TextEditingController();
  final _orgAddressController = TextEditingController();
  void initAuthCred() async {
    String userJson = authBox.get(HiveKeys.userBox);
    User user = User.fromJson(jsonDecode(userJson));
    setState(() {
      name = user.name;
      email = user.email;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAuthCred();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final data = {
        "org_name": _orgNameController.text.trim(),
        "org_email": _orgEmailController.text.trim(),
        "org_number": _orgNumberController.text.trim(),
        "org_address": _orgAddressController.text.trim(),
      };

      context.read<OrganizationBloc>().add(CreateOrganizationRequested(data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CreateOrganizationScreen(this);
  }
}
