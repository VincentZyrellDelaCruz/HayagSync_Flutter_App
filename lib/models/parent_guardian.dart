import 'package:hayagsync_app/models/student.dart';

class ParentGuardian {
  final String userId;
  final String parentCode;
  final String occupation;

  final List<Student> students; // NEW

  ParentGuardian({
    required this.userId,
    required this.parentCode,
    required this.occupation,
    this.students = const [],
  });

  factory ParentGuardian.fromJson(Map<String, dynamic> json) {
    return ParentGuardian(
      userId: json['user_id'],
      parentCode: json['parent_code'] ?? '',
      occupation: json['occupation'] ?? '',

      students: (json['students'] as List? ?? [])
          .map((e) => Student.fromJson(e))
          .toList(),
    );
  }
}