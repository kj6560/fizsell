import 'package:flutter/material.dart';

Future<bool> showExitConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Subscription Failure'),
              content: Text("You don't have an active subscription, Plz contact Admin"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('OK'),
                ),
              ],
            ),
      ) ??
      false;
}
