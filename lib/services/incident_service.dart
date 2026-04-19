import 'package:dio/dio.dart';
import 'package:hayagsync_app/core/constants/api_constants.dart';
import 'package:hayagsync_app/core/constants/app_route.dart';
import 'package:hayagsync_app/core/storage/token_storage.dart';
import 'package:hayagsync_app/models/incident/incident.dart';
import 'package:hayagsync_app/models/incident/local_evidence.dart';
import 'package:intl/intl.dart';

class IncidentService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {'Accept': 'application/json'},
    ),
  );

  static Future<void> setAuthHeader() async {
    final token = await TokenStorage.getToken();

    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  static Future<Incident> getIncidentById(String id) async {
    try {
      await setAuthHeader();

      final response = await _dio.get('${AppRoute.incidents}/$id');

      if (response.statusCode == 200) {
        return Incident.fromJson(response.data);
      }

      throw Exception('Failed to load incident detail.');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load incident detail.',
      );
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
    required List<LocalEvidence> evidences,
    String? location,
    String urgencyLevel = 'Low',
  }) async {
    try {
      await setAuthHeader();

      final formData = FormData();

      final now = DateTime.now();

      formData.fields.addAll([
        MapEntry('incident_title', title),
        MapEntry('description', description),
        MapEntry('category_id', categoryId.toString()),
        MapEntry(
          'incident_datetime',
          DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
        ),
        MapEntry('location', location ?? ''),
        MapEntry('urgency_level', urgencyLevel),
      ]);

      for (int i = 0; i < students.length; i++) {
        final student = students[i];

        formData.fields.addAll([
          MapEntry('students[$i][student_id]', student['student_id']),
          MapEntry(
            'students[$i][involvement_type]',
            student['involvement_type'],
          ),
          MapEntry('students[$i][notes]', student['notes'] ?? ''),
        ]);
      }

      for (int i = 0; i < evidences.length; i++) {
        final evidence = evidences[i];

        formData.files.add(
          MapEntry(
            'evidences[]',
            await MultipartFile.fromFile(
              evidence.file.path,
              filename: evidence.file.path.split('/').last,
            ),
          ),
        );

        formData.fields.add(MapEntry('captions[]', evidence.caption ?? ''));
      }

      final response = await _dio.post(
        AppRoute.incidents,
        data: formData,
        options: Options(headers: {'contentType': 'multipart/form-data'}),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to report incident.');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to report incident',
      );
    }
  }
}
