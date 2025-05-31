import 'dart:convert';

import '../../modules/auth/models/User.dart';
import '../local/hive_constants.dart';
import 'config.dart';

class AppConstants {
  static const String appName = "SwiftSell";
  static const String companyName = "Shiwkesh Schematics Private Limited";
  int? getUserRole(){
    String userJson = authBox.get(HiveKeys.userBox);
    User user = User.fromJson(jsonDecode(userJson));
    return user.role;
  }
}
