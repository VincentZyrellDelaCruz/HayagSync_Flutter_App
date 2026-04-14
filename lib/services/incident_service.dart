import 'package:dio/dio.dart';
import 'package:hayagsync_app/core/constants/api_constants.dart';
import 'package:hayagsync_app/core/constants/app_route.dart';
import 'package:hayagsync_app/core/storage/token_storage.dart';
import 'package:hayagsync_app/models/incident/incident.dart';
import 'package:hayagsync_app/models/student.dart';
import 'package:intl/intl.dart';

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

      final Response<dynamic> response = await _dio.get(AppRoute.incidents);

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

  static Future<void> reportIncident({
    required String title,
    required String description,
    required int categoryId,
    required List<Map<String, dynamic>> students,
    String? location,
    String urgencyLevel = 'Low',
  }) async {
    try {
      await setAuthHeader();

      final now = DateTime.now();

      final response = await _dio.post(
        AppRoute.incidents,
        data: {
          'incident_title': title,
          'description': description,
          'category_id': categoryId,
          'incident_datetime': DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
          'location': location,
          'urgency_level': urgencyLevel,
          'students': students,
        },
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to report incident.');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'failed to report incident',
      );
    }
  }
}
