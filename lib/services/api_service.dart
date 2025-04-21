import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  static Future<Response?> get(String url) async {
    try {
      return await _dio.get(url);
    } catch (e) {
      print("GET Error: $e");
      return null;
    }
  }

  static Future<Response?> post(String url, Map<String, dynamic> data) async {
    try {
      return await _dio.post(url, data: data);
    } catch (e) {
      print("POST Error: $e");
      return null;
    }
  }

  static Future<Response?> put(String url, Map<String, dynamic> data) async {
    try {
      return await _dio.put(url, data: data);
    } catch (e) {
      print("PUT Error: $e");
      return null;
    }
  }

  static Future<Response?> delete(String url) async {
    try {
      return await _dio.delete(url);
    } catch (e) {
      print("DELETE Error: $e");
      return null;
    }
  }
}
