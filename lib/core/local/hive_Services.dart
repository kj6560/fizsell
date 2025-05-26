import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../config/config.dart';
import 'hive_constants.dart';

class HiveService {
  static Future<void> openBoxes() async {
    try {
      await Hive.openBox(HiveConstantBox.authBox);
    } catch (e) {
      debugPrint('Error during box opening => $e');
    }
  }

  static Map<String, String> getHeaders() {
    final String? accessToken = authBox.get(HiveKeys.accessToken);
    if (accessToken == null || accessToken.isEmpty) return {};
    return {"Authorization": accessToken};
  }
}
