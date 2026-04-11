import 'package:dio/dio.dart';
import 'package:hayagsync_app/core/constants/api_constants.dart';
import 'package:hayagsync_app/core/storage/token_storage.dart';
import 'package:hayagsync_app/models/incident/incident.dart';

class IncidentService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  static Future<void> setAuthHeader() async {
    final token = await TokenStorage.getToken();

    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  static Future<List<Incident>> getIncidents() async {
    try {
      await setAuthHeader();

      final Response<dynamic> response = await _dio.get('/incidents');

      if (response.statusCode == 200) {
        final data = response.data;

        final List list = data is List ? data : data['data'];

        return list.map((e) => Incident.fromJson(e)).toList();
      }

      throw Exception('Unable to fetch incidents.');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Unable to fetch incidents.',
      );
    }
  }
}
