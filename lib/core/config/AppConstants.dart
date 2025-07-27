import 'dart:convert';

import '../../modules/auth/models/User.dart';
import '../local/hive_constants.dart';
import 'config.dart';

class AppConstants {
  static const String appName = "FizSell";
  static const String companyName = "Shiwkesh Schematics Private Limited";
  static const String AppVersion = "1.0.0";

  static var razorpayKey="";
  static int? getUserRole(){
    String userJson = authBox.get(HiveKeys.userBox);
    User user = User.fromJson(jsonDecode(userJson));
    return user.role;
  }

}
