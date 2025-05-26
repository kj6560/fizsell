import 'package:email_validator/email_validator.dart';

class MyValidator {
  static bool isValidPhoneNumber(String phoneNumber) {
    // Regular expression for a typical 10-digit Indian phone number
    // Modify the regex pattern according to the phone number format you want to validate
    RegExp regExp = RegExp(r"^[6-9]\d{9}$"); // Example for Indian phone numbers

    return regExp.hasMatch(phoneNumber);
  }

  static bool isValidEmail(String email) {
    return EmailValidator.validate(email);
  }

  static bool isValidPassword(String password) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    print(regExp.hasMatch(password));
    return regExp.hasMatch(password);
  }

  static bool isValidName(String name) {
    String pattern = r'^[a-zA-Z\s]{3,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(name) && name.isNotEmpty;
  }

  static bool isValidPinCode(String pinCode) {
    String pattern = r'^[1-9][0-9]{5}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(pinCode);
  }
}
