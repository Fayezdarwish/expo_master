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

  // POST بدون توكن (مثال: تسجيل دخول)
  static Future<Response?> post(String url, Map<String, dynamic> data) async {
    try {
      return await _dio.post(url, data: data);
    } catch (e) {
      print("POST Error: $e");
      return null;
    }
  }

  // POST مع توكن (مثال: إنشاء طلب عارض، إضافة منتج، إنشاء جناح)
  static Future<Response?> postWithToken(String url, Map<String, dynamic> data, String token) async {
    try {
      return await _dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      print("POST With Token Error: $e");
      return null;
    }
  }

  // GET بدون توكن (مثلاً: جلب الأقسام العامة)
  static Future<Response?> get(String url) async {
    try {
      return await _dio.get(url);
    } catch (e) {
      print("GET Error: $e");
      return null;
    }
  }

  // GET مع توكن (مثلاً: جلب منتجات العارض، طلبات العارض)
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

  // PUT بدون توكن (نادراً)
  static Future<Response?> put(String url, Map<String, dynamic> data) async {
    try {
      return await _dio.put(url, data: data);
    } catch (e) {
      print("PUT Error: $e");
      return null;
    }
  }

  // PUT مع توكن (مثلاً: تحديث بيانات)
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

  // DELETE مع توكن (مثلاً: حذف بيانات)
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

  // ================== دوال خاصة بالعارض ==================

  // إنشاء طلب عارض (POST /exhibitor/create-request)
  static Future<Response?> createExhibitorRequest(Map<String, dynamic> data, String token) async {
    // تأكد ان الحقول في data:
    // userId, exhibitionName, departmentId, contactPhone, notes, sectionId
    return postWithToken('/exhibitor/create-request', data, token);
  }

  // إضافة منتج (POST /exhibitor/add-products)
  static Future<Response?> addProduct(Map<String, dynamic> data, String token) async {
    // الحقول: exhibitorId, sectionId, productName, description?, price?
    return postWithToken('/exhibitor/add-products', data, token);
  }

  // جلب منتجات العارض (GET /exhibitor/my-products)
  static Future<Response?> getMyProducts(String token) async {
    return getWithToken('/exhibitor/my-products', token);
  }

  // إنشاء جناح (POST /exhibitor/create-wing)
  static Future<Response?> createWing(Map<String, dynamic> data, String token) async {
    // الحقول مهمة جدا وتتبع مودل Section:
    // name, departments_id, exhibitor_id
    return postWithToken('/exhibitor/create-wing', data, token);
  }

  // جلب الأقسام (GET /exhibitor/departments)
  static Future<Response?> getDepartmentsForExhibitor() async {
    return get('/exhibitor/departments');
  }

  // تتبع الطلب (GET /exhibitor/track-request) - تحتاج توكن
  static Future<Response?> trackRequest(String token) async {
    return getWithToken('/exhibitor/track-request', token);
  }

  // دفع الدفعة الأولى (POST /exhibitor/pay-initial)
  static Future<Response?> payInitial(Map<String, dynamic> data, String token) async {
    return postWithToken('/exhibitor/pay-initial', data, token);
  }

  // دفع الدفعة النهائية (POST /exhibitor/pay-final)
  static Future<Response?> payFinal(Map<String, dynamic> data, String token) async {
    return postWithToken('/exhibitor/pay-final', data, token);
  }
}
