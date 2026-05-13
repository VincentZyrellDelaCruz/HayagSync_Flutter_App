import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayagsync_app/models/pending_registration.dart';
import 'package:hayagsync_app/services/register_service.dart';

final registerProvider = NotifierProvider<RegisterNotifier, RegisterState>(
  RegisterNotifier.new,
);

class RegisterState {
  final bool isLoading;

  final String? email;
  final bool otpVerified;

  final Map<String, dynamic>? tempInfo;

  final PendingRegistration? registration;

  final File? selfie;
  final File? validId;
  final File? studentId;

  final bool success;
  final String? error;

  const RegisterState({
    this.isLoading = false,
    this.email,
    this.otpVerified = false,
    this.tempInfo,
    this.registration,
    this.selfie,
    this.validId,
    this.studentId,
    this.success = false,
    this.error,
  });

  RegisterState copyWith({
    bool? isLoading,
    String? email,
    bool? otpVerified,
    Map<String, dynamic>? tempInfo,
    PendingRegistration? registration,
    File? selfie,
    File? validId,
    File? studentId,
    bool? success,
    String? error,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      otpVerified: otpVerified ?? this.otpVerified,
      tempInfo: tempInfo ?? this.tempInfo,
      registration: registration ?? this.registration,
      selfie: selfie ?? this.selfie,
      validId: validId ?? this.validId,
      studentId: studentId ?? this.studentId,
      success: success ?? this.success,
      error: error,
    );
  }
}

class RegisterNotifier extends Notifier<RegisterState> {
  @override
  RegisterState build() {
    return const RegisterState();
  }

  /// =========================
  /// SEND OTP
  /// =========================
  Future<void> sendOtp(String email) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await RegisterService.sendOtp(email);

      state = state.copyWith(isLoading: false, email: email);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());

      rethrow;
    }
  }

  /// =========================
  /// VERIFY OTP
  /// =========================
  Future<void> verifyOtp(String otpCode) async {
    if (state.email == null) {
      throw Exception('Email not found.');
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await RegisterService.verifyOtp(email: state.email!, otpCode: otpCode);

      state = state.copyWith(isLoading: false, otpVerified: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());

      rethrow;
    }
  }

  /// =========================
  /// SAVE TEMP REGISTRATION INFO
  /// =========================
  void saveTempInfo({
    required String email,
    required String firstName,
    required String middleName,
    required String lastName,
    required String suffix,
    required String gender,
    required String birthdate,
    required String occupation,
    required String phoneNumber,
  }) {
    state = state.copyWith(
      tempInfo: {
        'email': email,
        'first_name': firstName,
        'middle_name': middleName,
        'last_name': lastName,
        'suffix': suffix,
        'gender': gender,
        'birthdate': birthdate,
        'occupation': occupation,
        'phone_number': phoneNumber,
      },
    );
  }

  /// =========================
  /// SAVE CAPTURED PROOF IMAGES
  /// =========================
  void setProofImages({File? selfie, File? validId, File? studentId}) {
    state = state.copyWith(
      selfie: selfie ?? state.selfie,
      validId: validId ?? state.validId,
      studentId: studentId ?? state.studentId,
    );
  }

  /// =========================
  /// SUBMIT REGISTRATION
  /// =========================
  Future<void> submitRegistration({
    required String studentId,
    required String relationship,
  }) async {
    if (state.tempInfo == null) {
      throw Exception('Registration information missing.');
    }

    if (state.selfie == null ||
        state.validId == null ||
        state.studentId == null) {
      throw Exception('Please capture all required proof images.');
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final temp = state.tempInfo!;

      final registration = PendingRegistration(
        email: temp['email'],
        firstName: temp['first_name'],
        lastName: temp['last_name'],
        middleName: temp['middle_name'],
        suffix: temp['suffix'],
        gender: temp['gender'],
        birthdate: temp['birthdate'],
        occupation: temp['occupation'],
        phoneNumber: temp['phone_number'],
        studentId: studentId,
        relationship: relationship,
      );

      final data = await RegisterService.submitRegistration(
        registration: registration,
        selfie: state.selfie!,
        validId: state.validId!,
        studentId: state.studentId!,
      );

      state = state.copyWith(
        isLoading: false,
        success: true,
        registration: PendingRegistration.fromJson(data['data']),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());

      rethrow;
    }
  }

  void saveRegistrationData(PendingRegistration registration) {
    state = state.copyWith(registration: registration);
  }

  /// =========================
  /// RESET STATE
  /// =========================
  void reset() {
    state = const RegisterState();
  }
}
