import 'package:dio/dio.dart';
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

  static Future<Response?> post(String url, Map<String, dynamic> data) async {
    try {
      return await _dio.post(url, data: data);
    } catch (e) {
      print("POST Error: $e");
      return null;
    }
  }

  static Future<Response?> postWithToken(String url, Map<String, dynamic> data, String token) async {
    try {
      return await _dio.post(url, data: data, options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ));
    } catch (e) {
      print("POST With Token Error: $e");
      return null;
    }
  }
}
