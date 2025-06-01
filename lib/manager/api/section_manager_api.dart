// ✅ 1. ملف SectionManagerApi يحتوي على createBooth وعمليات الإدارة

import 'package:dio/dio.dart';
import '../../services/api_service.dart';
import '../../services/token_storage.dart';

class SectionManagerApi {
  static Future<Map<String, dynamic>?> createBooth({
    required String name,
    required String description,
    required String area,
    required String location,
  }) async {
    try {
      final token = await TokenStorage.getToken();
      final userType = await TokenStorage.getUserType();
      if (token == null || userType != 3) {
        print("صلاحيات غير كافية أو مفقود التوكن");
        return null;
      }

      final response = await ApiService.postWithToken('/booths', {
        'name': name,
        'description': description,
        'area': area,
        'location': location,
      }, token);

      if (response != null && response.statusCode == 201) {
        return response.data;
      } else {
        print('Create Booth Error: ${response?.statusCode} → ${response?.data}');
        return null;
      }
    } catch (e) {
      print('Create Booth Exception: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> fetchBooths() async {
    try {
      final token = await TokenStorage.getToken();
      final response = await ApiService.getWithToken('/booths', token!);

      if (response != null && response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['booths']);
      }
      return null;
    } catch (e) {
      print('Fetch Booths Error: $e');
      return null;
    }
  }

  static Future<bool> deleteBooth(int id) async {
    try {
      final token = await TokenStorage.getToken();
      final response = await ApiService.deleteWithToken('/booths/$id', token!);
      return response != null && response.statusCode == 200;
    } catch (e) {
      print("Delete Booth Error: $e");
      return false;
    }
  }
}
