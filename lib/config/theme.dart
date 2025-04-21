import 'package:flutter/material.dart';

class AppTheme {
  static final themeData = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFFF5C518), // ذهبي فخم
    scaffoldBackgroundColor: const Color(0xFF1C1C1E), // رمادي غامق أنيق
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1C1C1E),
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Color(0xFFF5C518),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Color(0xFFF5C518)),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        color: Colors.white70,
        fontSize: 16,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF2C2C2E),
      labelStyle: TextStyle(color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      prefixIconColor: Color(0xFFF5C518),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFF5C518),
        foregroundColor: Colors.black,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.grey,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
  );
}
