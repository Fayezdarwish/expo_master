import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> saveUserType(int userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_type', userType);
  }


  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }



  static Future<int?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_type');
  }
}
