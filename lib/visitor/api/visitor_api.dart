import '../../services/api_service.dart';
import '../../services/token_storage.dart';

class VisitorApi {

  /// تسجيل الدخول 🔐
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await ApiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      if (response != null && response.statusCode == 200) {
        await TokenStorage.saveToken(response.data['token']); // حفظ التوكن بعد تسجيل الدخول
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

  /// إنشاء حساب (زائر أو عارض) 📝
  static Future<Map<String, dynamic>?> register(
      String name, String email, String password, int userType) async {
    try {
      final response = await ApiService.post('/auth/register', {
        'name': name,
        'email': email,
        'password': password,
        'userType': userType, // نرسل نوع المستخدم
      });

      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        return response.data;
      } else {
        print('Register Error: ${response?.statusCode} → ${response?.data}');
        return null;
      }
    } catch (e) {
      print('Register Exception: $e');
      return null;
    }
  }

  /// إنشاء حساب مدير قسم 🧑‍💼
  static Future<Map<String, dynamic>?> registerManager(
      String name, String email, String password) async {
    try {
      final response = await ApiService.post('/auth/register', {
        'name': name,
        'email': email,
        'password': password,
        'userType': 3, // مدير قسم دائماً userType = 3
      });

      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        return response.data;
      } else {
        print('Register Manager Error: ${response?.statusCode} → ${response?.data}');
        return null;
      }
    } catch (e) {
      print('Register Manager Exception: $e');
      return null;
    }
  }

  /// إنشاء قسم جديد 🏢
  static Future<Map<String, dynamic>?> createDepartment({
    required String name,
    required String description,
    required String startDate,
    required String endDate,
    required int managerId,
  }) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        print('Create Department Error: No token found');
        return null;
      }

      final response = await ApiService.postWithToken('/departments', {
        'name': name,
        'description': description,
        'startDate': startDate,
        'endDate': endDate,
        'manager_id': managerId,
      }, token);

      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        return response.data;
      } else {
        print('Create Department Error: ${response?.statusCode} → ${response?.data}');
        return null;
      }
    } catch (e) {
      print('Create Department Exception: $e');
      return null;
    }
  }
}
