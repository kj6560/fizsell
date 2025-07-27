library subscription_list_library;

import 'dart:convert';

import 'package:fizsell/core/widgets/base_screen.dart';
import 'package:fizsell/modules/Subscriptions/bloc/subscription_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/base_widget.dart';

part 'SubscriptionList.dart';

class Subscriptionlistcontroller extends StatefulWidget {
  const Subscriptionlistcontroller({super.key});

  @override
  State<Subscriptionlistcontroller> createState() =>
      SubscriptionlistcontrollerState();
}

class SubscriptionlistcontrollerState
    extends State<Subscriptionlistcontroller> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<SubscriptionBloc>(context).add(LoadSubscriptionList());
  }

  @override
  Widget build(BuildContext context) {
    return SubscriptionListScreen(this);
  }

  void purchase(int featureId) {
    Navigator.pushNamed(
      context,
      '/subscriptionDetail',
      arguments: {"id": featureId},
    );
  }
}
