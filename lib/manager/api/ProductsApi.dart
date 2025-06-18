import 'package:dio/dio.dart';
import '../../services/api_service.dart';
import '../../services/token_storage.dart';

class ProductsApi {
  // إنشاء منتج جديد
  static Future<bool> createProduct({
    required String name,
    required String description,
    required double price,
    required int departmentId,
  }) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) return false;

      final response = await ApiService.postWithToken(
        '/products',
        {
          'name': name,
          'description': description,
          'price': price,
          'department_id': departmentId,
        },
        token,
      );

      return response != null && (response.statusCode == 200 || response.statusCode == 201);
    } catch (e) {
      print('Create Product Error: $e');
      return false;
    }
  }

  // جلب كل المنتجات
  static Future<List<Map<String, dynamic>>?> getAllProducts() async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) return null;

      final response = await ApiService.getWithToken('/products', token);
      if (response != null && response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['products']);
      }
      return null;
    } catch (e) {
      print('Get All Products Error: $e');
      return null;
    }
  }

  // تعديل منتج
  static Future<bool> updateProduct({
    required int productId,
    required String name,
    required String description,
    required double price,
    required int departmentId,
  }) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) return false;

      final response = await ApiService.putWithToken(
        '/products/$productId',
        {
          'name': name,
          'description': description,
          'price': price,
          'department_id': departmentId,
        },
        token,
      );

      return response != null && response.statusCode == 200;
    } catch (e) {
      print('Update Product Error: $e');
      return false;
    }
  }

  // حذف منتج
  static Future<bool> deleteProduct(int productId) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) return false;

      final response = await ApiService.deleteWithToken('/products/$productId', token);
      return response != null && response.statusCode == 200;
    } catch (e) {
      print('Delete Product Error: $e');
      return false;
    }
  }

  // جلب منتج واحد بالتفصيل
  static Future<Map<String, dynamic>?> getProductById(int productId) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) return null;

      final response = await ApiService.getWithToken('/products/$productId', token);
      if (response != null && response.statusCode == 200) {
        return response.data['product'];
      }
      return null;
    } catch (e) {
      print('Get Product By ID Error: $e');
      return null;
    }
  }
}
