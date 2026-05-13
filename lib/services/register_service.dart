import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hayagsync_app/core/constants/api_constants.dart';
import 'package:hayagsync_app/models/pending_registration.dart';

class RegisterService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {'Accept': 'application/json'},
    ),
  );

  static Future<void> sendOtp(String email) async {
    await _dio.post('/register/otp', queryParameters: {'email': email});
  }

  static Future<void> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    await _dio.post(
      '/register/otp/verify',
      queryParameters: {'email': email, 'otp_code': otpCode},
    );
  }

  static Future<Map<String, dynamic>> submitRegistration({
    required PendingRegistration registration,
    required File selfie,
    required File validId,
    required File studentId,
  }) async {
    try {
      final formData = FormData.fromMap({
        'email': registration.email,
        'first_name': registration.firstName,
        'last_name': registration.lastName,
        'middle_name': registration.middleName,
        'suffix': registration.suffix,
        'gender': registration.gender,
        'birthdate': registration.birthdate,
        'occupation': registration.occupation,
        'phone_number': registration.phoneNumber,
        'student_id': registration.studentId,
        'relationship': registration.relationship,

        // IMPORTANT
        'proofs[]': [
          await MultipartFile.fromFile(selfie.path, filename: 'selfie.jpg'),

          await MultipartFile.fromFile(validId.path, filename: 'valid_id.jpg'),

          await MultipartFile.fromFile(
            studentId.path,
            filename: 'student_id.jpg',
          ),
        ],
      });

      final response = await _dio.post(
        '/register',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return response.data;
    } on DioException catch (e) {
      print(e.response?.data);
      rethrow;
    }
  }
}
