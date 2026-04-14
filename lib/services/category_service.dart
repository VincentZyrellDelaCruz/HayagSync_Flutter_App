import 'package:dio/dio.dart';
import 'package:hayagsync_app/core/constants/api_constants.dart';
import 'package:hayagsync_app/core/storage/token_storage.dart';
import 'package:hayagsync_app/models/incident/incident_category.dart';

class CategoryService {
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

  static Future<List<IncidentCategory>> getCategories() async {
    _setAuthHeader();

    final response = await _dio.get('/categories');

    final List data = response.data;

    return data.map((e) => IncidentCategory.fromJson(e)).toList();
  }
}
