library scheme_details_library;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/config.dart';
import '../../../../core/local/hive_constants.dart';
import '../../../core/widgets/base_screen.dart';
import '../../../core/widgets/base_widget.dart';
import '../../auth/models/User.dart';
import '../../products/models/products_model.dart';
import '../bloc/scheme_bloc.dart';
import '../models/scheme_model.dart';

part 'schemes_detail_screen.dart';

class SchemeDetailsController extends StatefulWidget {
  const SchemeDetailsController({super.key});

  @override
  State<SchemeDetailsController> createState() =>
      SchemeDetailsControllerState();
}

class SchemeDetailsControllerState extends State<SchemeDetailsController> {
  String email = "";
  String name = "";
  String scheme_id = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAuthCred();
    _getArguments();
  }

  void _getArguments() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = ModalRoute.of(context);
      if (route == null) {
        return;
      }

      final args = route.settings.arguments;
      if (args == null) {
        return;
      }
      if (args is Map<String, dynamic> && args.containsKey("scheme_id")) {
        String schemeId = args["scheme_id"].toString();
        setState(() {
          scheme_id = schemeId;
        });

        BlocProvider.of<SchemeBloc>(context)
            .add(LoadSchemeDetails(scheme_id: int.parse(scheme_id)));
      }
    });
  }

  void initAuthCred() async {
    String userJson = authBox.get(HiveKeys.userBox);
    User user = User.fromJson(jsonDecode(userJson));
    setState(() {
      name = user.name;
      email = user.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SchemeDetailScreen(this);
  }

  void deleteScheme() {
    BlocProvider.of<SchemeBloc>(context)
        .add(DeleteScheme(scheme_id: int.parse(scheme_id)));
  }
}
