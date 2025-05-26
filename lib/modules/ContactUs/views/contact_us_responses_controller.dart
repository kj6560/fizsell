library contact_us_response_library;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fizsell/core/widgets/base_screen.dart';
import '../../../core/config/config.dart';
import '../../../core/local/hive_constants.dart';
import '../../auth/models/User.dart';
import '../bloc/contact_us_bloc.dart';
import '../Dio/app_contact_repository.dart';
import '../models/AppContact.dart';
import 'package:fizsell/core/widgets/base_widget.dart';

part 'contact_us_responses.dart';

class ContactUsResponsesController extends StatefulWidget {

  const ContactUsResponsesController({super.key});

  @override
  ContactUsResponsesControllerState createState() => ContactUsResponsesControllerState();
}

class ContactUsResponsesControllerState extends State<ContactUsResponsesController> {
  late ContactUsBloc contactUsBloc;

  @override
  void initState() {
    super.initState();
    String token = authBox.get(HiveKeys.accessToken);
    String userJson = authBox.get(HiveKeys.userBox);
    User user = User.fromJson(jsonDecode(userJson));
    contactUsBloc = ContactUsBloc();
    contactUsBloc.add(FetchContactResponsesEvent(userId: user.id, token: token));
  }

  @override
  void dispose() {
    contactUsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContactUsResponses(this);
  }


}
