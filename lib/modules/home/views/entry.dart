import 'package:flutter/material.dart';

import '../../../../core/config/config.dart';
import '../../../core/local/hive_constants.dart';
import '../../../core/routes.dart';

class Entry extends StatefulWidget {
  const Entry({super.key});

  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final token = authBox.get(HiveKeys.accessToken);
      print('🟡 Entry check - token = $token');

      if (token != null) {
        print('🟢 Navigating to HOME');
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        print('🔴 Navigating to LOGIN');
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
              ),
            ),
            Center(child: Text("Initializing Plz wait..."))
          ],
        ),
      ),
    );
  }
}
