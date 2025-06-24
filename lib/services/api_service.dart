import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class ApiService {
  // إنشاء كائن Dio مع الإعدادات الأساسية (Base URL، المهلات، الهيدر)
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 50),
    receiveTimeout: const Duration(seconds: 50),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  /// دالة GET بدون توكن
  static Future<Response?> get(String url) async {
    try {
      final response = await _dio.get(url);
      return response;
    } catch (e) {
      print("GET Error: $e");
      return null;
    }
  }

  /// دالة POST بدون توكن
  static Future<Response?> post(String url, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(url, data: data);
      return response;
    } catch (e) {
      print("POST Error: $e");
      return null;
    }
  }

  /// دالة POST مع توكن (للطلبات التي تتطلب توثيق)
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

  /// دالة GET مع توكن
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

  /// دالة PUT بدون توكن (مهمة لـ resetPassword اللي ما فيها توكن)
  static Future<Response?> put(String url, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(url, data: data);
      return response;
    } catch (e) {
      print("PUT Error: $e");
      return null;
    }
  }

  /// دالة PUT مع توكن (تحديث بيانات مثلاً)
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

  /// دالة DELETE مع توكن
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
}
