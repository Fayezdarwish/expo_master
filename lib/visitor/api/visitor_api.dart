import '../../services/api_service.dart';
import '../../services/token_storage.dart';

class VisitorApi {
  /// تسجيل الدخول
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await ApiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      if (response != null && response.statusCode == 200) {
        final data = response.data;
        final String token = data['token'] as String;
        final int userType = data['userType'] as int;

        // حفظ التوكن ونوع المستخدم محلياً
        await TokenStorage.saveToken(token);
        await TokenStorage.saveUserType(userType);

        return {'token': token, 'userType': userType};
      } else {
        print('Login Error: ${response?.statusCode} → ${response?.data}');
      }
    } catch (e) {
      print('Login Exception: $e');
    }
    return null;
  }

  /// تسجيل مستخدم جديد
  static Future<Map<String, dynamic>?> register(
      String name, String email, String password, int userType) async {
    try {
      final response = await ApiService.post('/auth/register', {
        'name': name,
        'email': email,
        'password': password,
        'userType': userType,
      });

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        return response.data;
      } else {
        print('Register Error: ${response?.statusCode} → ${response?.data}');
      }
    } catch (e) {
      print('Register Exception: $e');
    }
    return null;
  }

  /// تسجيل مدير جديد (يتطلب توكن)
  static Future<int?> registerManager(String name, String email, String password) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        print('Register Manager Error: No token found');
        return null;
      }

      final response = await ApiService.postWithToken('/admin/create-manager', {
        'name': name,
        'email': email,
        'password': password,
        'userType': 3,
      }, token);

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        final data = response.data;
        if (data != null && data['managerId'] != null) {
          return data['managerId'] as int;
        } else {
          print('Register Manager: No managerId found in response');
        }
      } else {
        print('Register Manager Error: ${response?.statusCode} → ${response?.data}');
      }
    } catch (e) {
      print('Register Manager Exception: $e');
    }
    return null;
  }

  /// إنشاء قسم جديد (يتطلب توكن)
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

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        return response.data;
      } else {
        print('Create Department Error: ${response?.statusCode} → ${response?.data}');
      }
    } catch (e) {
      print('Create Department Exception: $e');
    }
    return null;
  }

  /// طلب إعادة تعيين كلمة المرور (لا يتطلب توكن)
  static Future<Map<String, dynamic>?> forgotPassword(String email) async {
    try {
      final response = await ApiService.post('/auth/forgot-password', {
        'email': email,
      });

      if (response != null && response.statusCode == 200) {
        return response.data;
      } else {
        print('Forgot Password Error: ${response?.statusCode} → ${response?.data}');
      }
    } catch (e) {
      print('Forgot Password Exception: $e');
    }
    return null;
  }

  /// إعادة تعيين كلمة المرور (PUT بدون توكن)
  static Future<Map<String, dynamic>?> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await ApiService.put('/auth/reset-password', {
        'email': email,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      });

      if (response != null && response.statusCode == 200) {
        return response.data;
      } else {
        print('Reset Password Error: ${response?.statusCode} → ${response?.data}');
      }
    } catch (e) {
      print('Reset Password Exception: $e');
    }
    return null;
  }

  /// جلب جميع الأقسام (يتطلب توكن)
  static Future<List<Map<String, dynamic>>?> getAllDepartments() async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        print('Get All Departments Error: No token found');
        return null;
      }
      final response = await ApiService.getWithToken('/departments', token);

      if (response != null && response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['departments']);
      } else {
        print('Get All Departments Error: ${response?.statusCode} → ${response?.data}');
      }
    } catch (e) {
      print('Get All Departments Exception: $e');
    }
    return null;
  }

  /// حذف قسم معين (يتطلب توكن)
  static Future<bool> deleteDepartment(int id) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        print('Delete Department Error: No token found');
        return false;
      }
      final response = await ApiService.deleteWithToken('/departments/$id', token);
      return response != null && response.statusCode == 200;
    } catch (e) {
      print('Delete Department Exception: $e');
      return false;
    }
  }

  /// تحديث بيانات قسم معين (يتطلب توكن)
  static Future<bool> updateDepartment({
    required int id,
    required String name,
    required String description,
    required String startDate,
    required String endDate,
    required int managerId,
  }) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        print('Update Department Error: No token found');
        return false;
      }

      final response = await ApiService.putWithToken(
        '/departments/$id',
        {
          'name': name,
          'description': description,
          'startDate': startDate,
          'endDate': endDate,
          'manager_id': managerId,
        },
        token,
      );

      return response != null && response.statusCode == 200;
    } catch (e) {
      print("Update Department Exception: $e");
      return false;
    }
  }

  /// جلب الأقسام (مكررة مع getAllDepartments لكن مع دعم أكثر لهيكل البيانات)
  static Future<List<Map<String, dynamic>>?> fetchDepartments() async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        print('Fetch Departments Error: No token found');
        return null;
      }

      final response = await ApiService.getWithToken('/departments', token);

      if (response != null && response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['departments'] != null) {
          return List<Map<String, dynamic>>.from(data['departments']);
        } else if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }
      }
    } catch (e) {
      print('Fetch Departments Exception: $e');
    }
    return null;
  }
  static Future<Map<String, dynamic>?> submitExhibitorRequest(Map<String, dynamic> requestData) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        print('Submit Exhibitor Request Error: No token found');
        return null;
      }

      final response = await ApiService.postWithToken('/exhibitor/request', requestData, token);

      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        return response.data;
      } else {
        print('Submit Exhibitor Request Error: ${response?.statusCode} → ${response?.data}');
        return null;
      }
    } catch (e) {
      print('Submit Exhibitor Request Exception: $e');
      return null;
    }
  }
  /// جلب حالة طلب العارض (يتطلب توكن)
  static Future<Map<String, dynamic>?> getExhibitorRequestStatus(int requestId, String token) async {
    try {
      final response = await ApiService.getWithToken('/exhibitor/request/$requestId', token);

      if (response != null && response.statusCode == 200) {
        return response.data;
      } else {
        print('Get Exhibitor Request Status Error: ${response?.statusCode} → ${response?.data}');
      }
    } catch (e) {
      print('Get Exhibitor Request Status Exception: $e');
    }
    return null;
  }


}
