import '../../services/api_service.dart';
import '../../services/token_storage.dart';

class VisitorApi {
  /// Helper method to retrieve token safely
  static Future<String?> _getToken() async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      print('Token not found.');
    }
    return token;
  }

  /// Login user and store token and user type
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await ApiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      if (response?.statusCode == 200) {
        final data = response!.data;
        await TokenStorage.saveToken(data['token']);
        await TokenStorage.saveUserType(data['userType']);
        return data;
      } else {
        print('Login Error: ${response?.statusCode} → ${response?.data}');
      }
    } catch (e) {
      print('Login Exception: $e');
    }
    return null;
  }

  /// Register a new user
  static Future<Map<String, dynamic>?> register(String name, String email, String password, int userType) async {
    try {
      final response = await ApiService.post('/auth/register', {
        'name': name,
        'email': email,
        'password': password,
        'userType': userType,
      });

      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return response!.data;
      } else {
        print('Register Error: ${response?.statusCode} → ${response?.data}');
      }
    } catch (e) {
      print('Register Exception: $e');
    }
    return null;
  }

  /// Register a manager (admin use)
  static Future<int?> registerManager(String name, String email, String password) async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await ApiService.postWithToken('/admin/create-manager', {
        'name': name,
        'email': email,
        'password': password,
        'userType': 3,
      }, token);

      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return response!.data['managerId'] as int?;
      } else {
        print('Register Manager Error: ${response?.statusCode} → ${response?.data}');
      }
    } catch (e) {
      print('Register Manager Exception: $e');
    }
    return null;
  }

  /// Create a new department
  static Future<Map<String, dynamic>?> createDepartment({
    required String name,
    required String description,
    required String startDate,
    required String endDate,
    required int managerId,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await ApiService.postWithToken('/departments', {
        'name': name,
        'description': description,
        'startDate': startDate,
        'endDate': endDate,
        'manager_id': managerId,
      }, token);

      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return response!.data;
      } else {
        print('Create Department Error: ${response?.statusCode} → ${response?.data}');
      }
    } catch (e) {
      print('Create Department Exception: $e');
    }
    return null;
  }

  /// Update existing department
  static Future<bool> updateDepartment({
    required int id,
    required String name,
    required String description,
    required String startDate,
    required String endDate,
    required int managerId,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await ApiService.putWithToken('/departments/$id', {
        'name': name,
        'description': description,
        'startDate': startDate,
        'endDate': endDate,
        'manager_id': managerId,
      }, token);

      return response?.statusCode == 200;
    } catch (e) {
      print("Update Department Exception: $e");
      return false;
    }
  }

  /// Delete a department
  static Future<bool> deleteDepartment(int id) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await ApiService.deleteWithToken('/departments/$id', token);
      return response?.statusCode == 200;
    } catch (e) {
      print('Delete Department Exception: $e');
      return false;
    }
  }
  /// Get all departments (for exhibitor)
  static Future<List<Map<String, dynamic>>?> getAllDepartmentsforexhibitor() async {
    try {
      final token = await _getToken();
      if (token == null) {
        print('Token not found. User not logged in.');
        return null;
      }

      final response = await ApiService.getRequest(
        '/exhibitor/departments',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response?.statusCode == 200) {
        final data = response!.data;
        print('Departments response: $data');

        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        } else if (data is Map && data.containsKey('departments')) {
          return List<Map<String, dynamic>>.from(data['departments']);
        }
      } else {
        print('Get Departments Error: ${response?.statusCode} → ${response?.data}');
      }
    } catch (e) {
      print('Get Departments Exception: $e');
    }
    return null;
  }

  /// Get all departments
  static Future<List<Map<String, dynamic>>?> getAllDepartments() async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await ApiService.get('/exhibitor/departments');

      if (response?.statusCode == 200) {
        print('Response Data: ${response!.data}');

        final data = response.data;
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        } else if (data is Map && data.containsKey('departments')) {
          return List<Map<String, dynamic>>.from(data['departments']);
        }
      } else {
        print('Get Departments Error: ${response?.statusCode} → ${response?.data}');
      }
    } catch (e) {
      print('Get Departments Exception: $e');
    }
    return null;
  }


  /// Forgot password request
  static Future<Map<String, dynamic>?> forgotPassword(String email) async {
    try {
      final response = await ApiService.post('/auth/forgot-password', {'email': email});
      if (response?.statusCode == 200) return response!.data;
    } catch (e) {
      print('Forgot Password Exception: $e');
    }
    return null;
  }

  /// Reset password
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

      if (response?.statusCode == 200) return response!.data;
    } catch (e) {
      print('Reset Password Exception: $e');
    }
    return null;
  }

  /// Submit exhibitor request
  static Future<bool> submitExhibitorRequest(Map<String, dynamic> requestData) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await ApiService.postWithToken('/exhibitor/request', requestData, token);
      return response?.statusCode == 200 || response?.statusCode == 201;
    } catch (e) {
      print('Submit Exhibitor Request Exception: $e');
      return false;
    }
  }

  /// Get current user's exhibitor request
  static Future<Map<String, dynamic>?> getMyRequest() async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await ApiService.getWithToken('/exhibitor/my-request', token);
      if (response?.statusCode == 200) return response!.data;
    } catch (e) {
      print('Get My Request Exception: $e');
    }
    return null;
  }

  /// Pay for exhibitor wing
  static Future<bool> payForWing() async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await ApiService.postWithToken('/exhibitor/pay', {}, token);
      return response?.statusCode == 200 || response?.statusCode == 201;
    } catch (e) {
      print('Pay For Wing Exception: $e');
      return false;
    }
  }

  /// Create a new wing
  static Future<Map<String, dynamic>?> createWing(Map<String, dynamic> wingData) async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await ApiService.postWithToken('/wings', wingData, token);
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return response!.data;
      }
    } catch (e) {
      print('Create Wing Exception: $e');
    }
    return null;
  }

  /// Get current user's tasks
  static Future<List<Map<String, dynamic>>?> getMyTasks() async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await ApiService.getWithToken('/wings/tasks', token);
      if (response?.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response!.data['tasks']);
      }
    } catch (e) {
      print('Get My Tasks Exception: $e');
    }
    return null;
  }

  /// Add new task to wing
  static Future<bool> addTask(Map<String, dynamic> taskData) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await ApiService.postWithToken('/wings/tasks', taskData, token);
      return response?.statusCode == 200 || response?.statusCode == 201;
    } catch (e) {
      print('Add Task Exception: $e');
      return false;
    }
  }
}
