import '../../../../services/api_service.dart';
import 'exibition_model.dart';

class ExhibitionApi {
  static Future<bool> createExhibition(Exhibition exhibition, String token) async {
    final response = await ApiService.postWithToken('/admin/exhibitions', exhibition.toJson(), token);

    if (response != null && response.statusCode == 201) {
      return true;
    } else {
      print('Create Exhibition Error: ${response?.statusCode} → ${response?.data}');
      return false;
    }
  }
}
