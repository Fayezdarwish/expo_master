import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String tokenKey = 'auth_token';
  static const String userTypeKey = 'user_type';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
    print('✅ Token saved: $token');
  }

  static Future<void> saveUserType(int userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(userTypeKey, userType);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static Future<int?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userTypeKey);
  }
}