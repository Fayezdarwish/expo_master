import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class ApiService {
  // إنشاء Dio مع الإعدادات الأساسية
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl, // الرابط الأساسي للسيرفر (مثال: http://localhost:3000)
    connectTimeout: const Duration(seconds: 50), // مهلة الاتصال
    receiveTimeout: const Duration(seconds: 50), // مهلة استقبال البيانات
    headers: {
      'Content-Type': 'application/json', // نوع البيانات المرسلة
      'Accept': 'application/json',       // نوع البيانات المطلوبة من السيرفر
    },
  ));

  // دالة POST بدون توكن (تُستخدم مثلاً لتسجيل الدخول أو إنشاء حساب)
  static Future<Response?> post(String url, Map<String, dynamic> data) async {
    try {
      return await _dio.post(url, data: data);
    } catch (e) {
      print("POST Error: $e");
      return null;
    }
  }

  // دالة POST مع توكن (للمسارات المحمية التي تحتاج صلاحية دخول)
  static Future<Response?> postWithToken(String url, Map<String, dynamic> data, String token) async {
    try {
      return await _dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // إدخال التوكن في الهيدر
          },
        ),
      );
    } catch (e) {
      print("POST With Token Error: $e");
      return null;
    }
  }

  // دالة GET لجلب بيانات (مثال: عرض كل الأقسام)
  static Future<Response?> get(String url) async {
    try {
      return await _dio.get(url);
    } catch (e) {
      print("GET Error: $e");
      return null;
    }
  }

  // دالة GET مع توكن لجلب بيانات محمية (مثال: تفاصيل لوحة تحكم مدير المعرض)
  static Future<Response?> getWithToken(String url, String token) async {
    try {
      return await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print("GET With Token Error: $e");
      return null;
    }
  }

  // دالة PUT لتعديل بيانات بدون توكن (نادراً ما تستخدم بدون توكن)
  static Future<Response?> put(String url, Map<String, dynamic> data) async {
    try {
      return await _dio.put(url, data: data);
    } catch (e) {
      print("PUT Error: $e");
      return null;
    }
  }

  // دالة PUT مع توكن (لتحديث قسم مثلاً)
  static Future<Response?> putWithToken(String url, Map<String, dynamic> data, String token) async {
    try {
      return await _dio.put(
        url,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print("PUT With Token Error: $e");
      return null;
    }
  }

  // دالة DELETE لحذف بيانات (قسم، مستخدم... إلخ) باستخدام توكن
  static Future<Response?> deleteWithToken(String url, String token) async {
    try {
      return await _dio.delete(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print("DELETE With Token Error: $e");
      return null;
    }
  }

}