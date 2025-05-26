import 'package:flutter/material.dart';

TextFormField CustomInputField({
  required TextEditingController controller,
  String? hintText,
  String? labelText,
  Widget? prefixIcon,
  Widget? suffixIcon,
  String? Function(String?)? validator,
  TextInputType? keyboardType,
  bool obscureText = false,
  TextStyle hintStyle = const TextStyle(color: Colors.grey, fontSize: 14),
  TextStyle? textStyle,
  int errorMaxLines = 2,
  void Function(String)? onChanged,
}) {
  return TextFormField(
    onChanged: onChanged,
    validator: validator,
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscureText,
    style: textStyle,
    decoration: InputDecoration(
      errorStyle: TextStyle(
          color: Color.fromRGBO(227, 11, 11, 1),
          fontFamily: 'inter',
          fontWeight: FontWeight.w500,
          fontSize: 12),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      hintText: hintText,
      hintStyle: hintStyle,
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(10),
      errorMaxLines: errorMaxLines,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromRGBO(19, 146, 127, 1)),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromRGBO(227, 11, 11, 1),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromRGBO(227, 11, 11, 1),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
