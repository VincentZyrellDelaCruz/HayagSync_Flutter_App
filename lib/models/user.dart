import 'package:hayagsync_app/models/parent_guardian.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String? middleName;
  final String? suffix;

  final String gender;
  final DateTime? birthdate;

  final String email;
  final String? phoneNumber;
  final String? profileImageUrl;

  final String status;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  // 🔹 Existing relationship (keep this)
  final ParentGuardian? parentGuardian;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.middleName,
    this.suffix,
    required this.gender,
    this.birthdate,
    required this.email,
    this.phoneNumber,
    this.profileImageUrl,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.parentGuardian,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],

      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      middleName: json['middle_name'],
      suffix: json['suffix'],

      gender: json['gender'] ?? '',

      birthdate: json['birthdate'] != null
          ? DateTime.tryParse(json['birthdate'])
          : null,

      email: json['email'] ?? '',
      phoneNumber: json['phone_number'],
      profileImageUrl: json['profile_image_url'],

      status: json['status'] ?? 'Active',

      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,

      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,

      // 🔥 IMPORTANT: works for BOTH cases
      parentGuardian: json['parent_guardian'] != null
          ? ParentGuardian.fromJson(json['parent_guardian'])
          : null,
    );
  }
}