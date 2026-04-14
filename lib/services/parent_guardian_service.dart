import 'package:dio/dio.dart';
import 'package:hayagsync_app/core/constants/api_constants.dart';
import 'package:hayagsync_app/core/storage/token_storage.dart';

class ParentGuardianService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  static Future<void> _setAuthHeader() async {
    final token = await TokenStorage.getToken();

    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }
  
}