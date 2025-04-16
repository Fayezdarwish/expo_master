import '../services/api_service.dart';

class VisitorApi {
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await ApiService.post('/auth/login', {
      'email': email,
      'password': password,
    });

    if (response != null && response.statusCode == 200) {
      return response.data;
    } else {
      return null;
    }
  }
}
