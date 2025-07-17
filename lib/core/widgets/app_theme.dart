import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: const Color(0xFFC9B259),
      // Indigo Blue
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      // Light Grey
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      cardColor: Colors.white,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: const Color(0xFFFF6F61), // Coral
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Color(0xFF212121),
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Color(0xFF757575),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFFC9B259),
      scaffoldBackgroundColor: const Color(0xFFFFFFFF), // white background
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFB5A13F),
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      cardColor: Colors.white,
      colorScheme: const ColorScheme.light().copyWith(
        secondary: Color(0xFFFF6F61),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: Color(0xFF757575)),
        bodyMedium: TextStyle(color: Colors.black),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.white,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: Color(0xFFC9B259),
        textColor: Colors.black,
      ),
    );
  }

}