import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutHelper {
  static Future<void> logoutUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // مسح التوكن وكل البيانات

    // الانتقال إلى صفحة تسجيل الدخول بدون رجوع للخلف
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
