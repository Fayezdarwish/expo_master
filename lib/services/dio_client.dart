  import 'package:dio/dio.dart';

  class DioClient {
    static final Dio dio = Dio(BaseOptions(
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer YOUR_TOKEN', إذا كان عندك توكن
      },
    ));
  }
