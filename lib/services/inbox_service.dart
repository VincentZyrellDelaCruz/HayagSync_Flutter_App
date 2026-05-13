import 'package:dio/dio.dart';
import 'package:hayagsync_app/core/constants/api_constants.dart';
import 'package:hayagsync_app/core/storage/token_storage.dart';
import 'package:hayagsync_app/models/inbox.dart';

class InboxService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  static Future<List<Inbox>> getInboxList() async {
    try {
      final token = await TokenStorage.getToken();

      final response = await _dio.get(
        '/inboxes',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return (response.data as List)
          .map((e) => Inbox.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Unable to load inbox',
      );
    }
  }

  static Future<Inbox> getInboxDetail(int id) async {
    try {
      final token = await TokenStorage.getToken();

      final response = await _dio.get(
        '/inboxes/$id',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return Inbox.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Unable to load inbox detail',
      );
    }
  }
}