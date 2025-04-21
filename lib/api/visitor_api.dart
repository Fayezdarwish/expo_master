import '../services/api_service.dart';

class VisitorApi {
  /// 🔐 تسجيل الدخول
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await ApiService.post('/auth/login', {
        'email': email,
        'password': password,
      });
  
      if (response != null && response.statusCode == 200) {
        return response.data;
      } else {
        print('Login Error: ${response?.statusCode} → ${response?.data}');
        return null;
      }
    } catch (e) {
      print('Login Exception: $e');
      return null;
    }
  }

  /// 📝 إنشاء حساب جديد
  static Future<Map<String, dynamic>?> register(String name, String email, String password) async {
    try {
      final response = await ApiService.post('/auth/register', {
        'name': "fayez",
        'email': "fayez@gmail.com",
        'password': "123456789",
      });

      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        return response.data;
      } else {
        print('Register Error: ${response?.statusCode} → ${response?.data}');
        print('Register response: ${response?.statusCode}');
        print('Register data: ${response?.data}');

        return null;
      }
    } catch (e) {
      print('Register Exception: $e');
      return null;
    }
  }
}
