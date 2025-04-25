import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  // حفظ التوكن بعد إزالة كلمة Bearer إن وجدت
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    // إزالة كلمة Bearer والمسافة إن وجدت
    final cleanedToken = token.replaceFirst('Bearer ', '');
    await prefs.setString('token', cleanedToken);
  }

  // استرجاع التوكن المخزن
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // حذف التوكن عند تسجيل الخروج
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}