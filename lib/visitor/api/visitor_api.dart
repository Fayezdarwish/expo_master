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
  static Future<Map<String, dynamic>?> register(String name, String email, String password, int userType) async {
    try {
      final response = await ApiService.post('/auth/register', {
        'name': name,
        'email': email,
        'password': password,
        'userType': userType,
      });

      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        return response.data;
      } else {
        print('Register Error: ${response?.statusCode} → ${response?.data}');
      }
    } catch (e) {
      print('Register Exception: $e');
    }
    return null;
  }

  /// تسجيل مدير جديد
  static Future<int?> registerManager(String name, String email, String password) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) return null;

      final response = await ApiService.postWithToken('/admin/create-manager', {
        'name': name,
        'email': email,
        'password': password,
        'userType': 3,
      }, token);

      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        return response.data['managerId'] as int?;
      } else {
        print('Register Manager Error: ${response?.statusCode} → ${response?.data}');
      }
    } catch (e) {
      print('Register Manager Exception: $e');
    }
    return null;
  }

  /// إنشاء قسم
  static Future<Map<String, dynamic>?> createDepartment({
    required String name,
    required String description,
    required String startDate,
    required String endDate,
    required int managerId,
  }) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) return null;

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
      }
    } catch (e) {
      print('Create Department Exception: $e');
    }
    return null;
  }

  /// إعادة تعيين كلمة المرور
  static Future<Map<String, dynamic>?> forgotPassword(String email) async {
    try {
      final response = await ApiService.post('/auth/forgot-password', {'email': email});
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

  /// جلب كل الأقسام
  static Future<List<Map<String, dynamic>>?> getAllDepartments() async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) return null;

      final response = await ApiService.getWithToken('/departments', token);

      if (response != null && response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['departments']);
      } else {
        print('Get Departments Error: ${response?.statusCode} → ${response?.data}');
      }
    } catch (e) {
      print('Get Departments Exception: $e');
    }
    return null;
  }

  /// حذف قسم
  static Future<bool> deleteDepartment(int id) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) return false;

      final response = await ApiService.deleteWithToken('/departments/$id', token);
      return response?.statusCode == 200;
    } catch (e) {
      print('Delete Department Exception: $e');
      return false;
    }
  }

  /// تعديل قسم
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
      if (token == null) return false;

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

      return response?.statusCode == 200;
    } catch (e) {
      print("Update Department Exception: $e");
      return false;
    }
  }

  /// تقديم طلب عارض
  static Future<bool> submitExhibitorRequest(Map<String, dynamic> requestData, String token) async {
    try {
      final response = await ApiService.postWithToken('/exhibitor/request', requestData, token);
      return response != null && (response.statusCode == 200 || response.statusCode == 201);
    } catch (e) {
      print('Submit Exhibitor Request Exception: $e');
      return false;
    }
  }

  /// جلب حالة طلب المستخدم الحالي
  static Future<Map<String, dynamic>?> getMyRequest(String token) async {
    try {
      final response = await ApiService.getWithToken('/exhibitor/my-request', token);
      if (response != null && response.statusCode == 200) {
        return response.data;
      } else {
        print('Get My Request Error: ${response?.statusCode} → ${response?.data}');
      }
    } catch (e) {
      print('Get My Request Exception: $e');
    }
    return null;
  }

  /// دفع الإيجار لجناح
  static Future<bool> payForWing(String token) async {
    try {
      final response = await ApiService.postWithToken('/exhibitor/pay', {}, token);
      return response != null && (response.statusCode == 200 || response.statusCode == 201);
    } catch (e) {
      print('Pay For Wing Exception: $e');
      return false;
    }
  }

  /// إنشاء جناح جديد
  static Future<Map<String, dynamic>?> createWing(Map<String, dynamic> wingData, String token) async {
    try {
      final response = await ApiService.postWithToken('/wings', wingData, token);
      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        return response.data;
      } else {
        print('Create Wing Error: ${response?.statusCode} → ${response?.data}');
      }
    } catch (e) {
      print('Create Wing Exception: $e');
    }
    return null;
  }

  /// جلب المهام الخاصة بالجناح الحالي
  static Future<List<Map<String, dynamic>>?> getMyTasks(String token) async {
    try {
      final response = await ApiService.getWithToken('/wings/tasks', token);
      if (response != null && response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['tasks']);
      } else {
        print('Get My Tasks Error: ${response?.statusCode} → ${response?.data}');
      }
    } catch (e) {
      print('Get My Tasks Exception: $e');
    }
    return null;
  }

  /// إضافة مهمة للجناح
  static Future<bool> addTask(Map<String, dynamic> taskData, String token) async {
    try {
      final response = await ApiService.postWithToken('/wings/tasks', taskData, token);
      return response != null && (response.statusCode == 200 || response.statusCode == 201);
    } catch (e) {
      print('Add Task Exception: $e');
      return false;
    }
  }
}
