import 'package:dio/dio.dart';
import 'package:hayagsync_app/core/constants/api_constants.dart';

class AuthService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final Response<dynamic> response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      throw Exception(response.data['message'] ?? 'Login Failed');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login Failed');
    }
  }

  // static Future<Map<String, dynamic>> register() {}

  static Future<Map<String, dynamic>> profile(String token) async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      throw Exception(response.data['message'] ?? 'Unable to load profile');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Unable to load profile');
    }
  }

  static Future<void> logout(String token) async {
    try {
      final Response<dynamic> response = await _dio.post(
        '/logout',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        throw Exception('Logout Failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Logout Failed');
    }
  }
}
