import 'package:dio/dio.dart';
import '../../constants/api_constants.dart';
import '../../services/api_service.dart';
import '../../services/dio_client.dart';
import '../../services/token_storage.dart';

class BoothApi {
  static final Dio _dio = DioClient.dio;

  static Future<Map<String, dynamic>?> getBoothStats() async {
    try {
      final res = await _dio.get('$baseUrl/booth/stats');
      return res.data;
    } catch (e) {
      print('❌ Error in getBoothStats: $e');
      return null;
    }
  }

  static Future<bool> deleteProduct(int id) async {
    try {
      final res = await _dio.delete('$baseUrl/booth/products/$id');
      return res.statusCode == 200;
    } catch (e) {
      print('❌ Error in deleteProduct: $e');
      return false;
    }
  }

  static Future<bool> editBooth({
    required String name,
    required String description,
    required String logoUrl,
  }) async {
    try {
      final res = await _dio.put(
        '$baseUrl/booth',
        data: {
          'name': name,
          'description': description,
          'logo_url': logoUrl,
        },
      );
      return res.statusCode == 200;
    } catch (e) {
      print('❌ Error in editBooth: $e');
      return false;
    }
  }
  static Future<bool> payForBooth({
    required double amount,
    required String method,
  }) async {
    try {
      final res = await _dio.post(
        '$baseUrl/booth/pay',
        data: {
          'amount': amount,
          'method': method,
        },
      );
      return res.statusCode == 200;
    } catch (e) {
      print('❌ Error in payForBooth: $e');
      return false;
    }
  }
  static Future<Map<String, dynamic>?> getMyBookingRequest() async {
    try {
      final res = await _dio.get('$baseUrl/booth/my-booking');
      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      print('❌ Error in getMyBookingRequest: $e');
    }
    return null;
  }
  static Future<List<Map<String, dynamic>>?> getComments() async {
    try {
      final res = await _dio.get('$baseUrl/booth/comments');
      if (res.statusCode == 200) {
        // نتأكد من تحويل الداتا إلى List<Map>
        List data = res.data;
        return data.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (e) {
      print('❌ Error in getComments: $e');
    }
    return null;
  }
  static Future<Map<String, dynamic>?> getBooth() async {
    try {
      final res = await _dio.get('$baseUrl/booth');
      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      print('Error in getBooth: $e');
    }
    return null;
  }

  static Future<bool> updateBooth({
    required String name,
    required String description,
    required String imageUrl,
    required String contactLink,
  }) async {
    try {
      final res = await _dio.put('$baseUrl/booth', data: {
        'name': name,
        'description': description,
        'image_url': imageUrl,
        'contact_link': contactLink,
      });
      return res.statusCode == 200;
    } catch (e) {
      print('Error in updateBooth: $e');
      return false;
    }
  }

  static Future<int> getVisitorStats() async {
  try {
  final token = await TokenStorage.getToken();
  if (token == null) return 0;

  final response = await ApiService.getWithToken('/booth/visitor-stats', token);
  if (response != null && response.statusCode == 200) {
  return response.data['visitor_count'] ?? 0;
  }
  return 0;
  } catch (e) {
  print('Error in getVisitorStats: $e');
  return 0;
  }
  }


}
