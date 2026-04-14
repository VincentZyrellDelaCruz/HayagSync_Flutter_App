import 'package:dio/dio.dart';
import 'package:hayagsync_app/core/constants/api_constants.dart';
import 'package:hayagsync_app/core/storage/token_storage.dart';
import 'package:hayagsync_app/models/student.dart';

class StudentService {
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

  static Future<List<Student>> getAllStudents() async {
    try {
      await _setAuthHeader();

      final response = await _dio.get('/students');

      if (response.statusCode == 200) {
        final List data = response.data is List
            ? response.data
            : response.data['data'];

        return data.map((e) => Student.fromJson(e)).toList();
      }

      throw Exception('Unable to fetch all students.');
    } on DioException catch (_) {
      throw Exception('Unable to fetch all students.');
    }
  }

  static Future<List<Student>> getMyStudents() async {
    try {
      await _setAuthHeader();

      final response = await _dio.get('/parent/students');

      if (response.statusCode == 200) {
        final List data = response.data;

        return data
            .expand((e) => (e['students'] as List))
            .map((s) => Student.fromJson(s))
            .toList();
      }

      throw Exception('Unable to fetch your children/students.');
    } on DioException catch (_) {
      throw Exception('Unable to fetch your children/students.');
    }
  }
}
