class Student {
  final String id;
  final String schoolId;
  final String studentNumber;

  final String firstName;
  final String lastName;
  final String? middleName;
  final String? suffix;

  final String gender;
  final DateTime birthdate;
  final String email;
  final String? phoneNumber;

  final DateTime createdAt;

  // Pivot fields (optional)
  final String? involvementType; // for incidents
  final String? notes;           // for incidents
  final String? relationship;    // for parent_guardian

  Student({
    required this.id,
    required this.schoolId,
    required this.studentNumber,
    required this.firstName,
    required this.lastName,
    this.middleName,
    this.suffix,
    required this.gender,
    required this.birthdate,
    required this.email,
    this.phoneNumber,
    required this.createdAt,

    this.involvementType,
    this.notes,
    this.relationship,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      schoolId: json['school_id'],
      studentNumber: json['student_number'] ?? '',

      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      middleName: json['middle_name'],
      suffix: json['suffix'],

      gender: json['gender'] ?? '',
      birthdate: DateTime.parse(json['birthdate']),
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'],

      createdAt: DateTime.parse(json['created_at']),

      // Pivot handling (works for BOTH APIs)
      involvementType: json['pivot']?['involvement_type'],
      notes: json['pivot']?['notes'],
      relationship: json['pivot']?['relationship'],
    );
  }
}