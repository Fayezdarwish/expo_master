// api_service.dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 50),
    receiveTimeout: const Duration(seconds: 50),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  static Future<Response?> get(String url) async {
    try {
      final response = await _dio.get(url);
      return response;
    } catch (e) {
      print("GET Error: $e");
      return null;
    }
  }

  static Future<Response?> post(String url, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(url, data: data);
      return response;
    } catch (e) {
      print("POST Error: $e");
      return null;
    }
  }

  static Future<Response?> postWithToken(String url, Map<String, dynamic> data, String token) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      print("POST With Token Error: $e");
      return null;
    }
  }

  static Future<Response?> getWithToken(String url, String token) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      print("GET With Token Error: $e");
      return null;
    }
  }

  static Future<Response?> put(String url, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(url, data: data);
      return response;
    } catch (e) {
      print("PUT Error: $e");
      return null;
    }
  }

  static Future<Response?> putWithToken(String url, Map<String, dynamic> data, String token) async {
    try {
      final response = await _dio.put(
        url,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      print("PUT With Token Error: $e");
      return null;
    }
  }

  static Future<Response?> deleteWithToken(String url, String token) async {
    try {
      final response = await _dio.delete(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      print("DELETE With Token Error: $e");
      return null;
    }
  }

  // ✅ Get token from SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // ✅ Get all departments from API
  static Future<List<Map<String, dynamic>>?> getAllDepartments() async {
    try {
      final token = await _getToken();
      if (token == null) {
        print("Token is null");
        return null;
      }

      final response = await getWithToken('/departments', token);
      if (response?.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response!.data['departments']);
      } else {
        print('Get Departments Error: ${response?.statusCode} → ${response?.data}');
      }
    } catch (e) {
      print('Get Departments Exception: $e');
    }
    return null;
  }
  static Future<Response?> getRequest(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await _dio.get(endpoint, options: Options(headers: headers));
      return response;
    } catch (e) {
      print('GET error: $e');
      return null;
    }
  }


}
