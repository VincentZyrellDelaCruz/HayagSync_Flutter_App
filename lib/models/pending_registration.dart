class PendingRegistration {
  final String email;
  final String firstName;
  final String lastName;
  final String? middleName;
  final String? suffix;
  final String gender;
  final String birthdate;
  final String occupation;
  final String phoneNumber;
  final String studentId;
  final String relationship;

  const PendingRegistration({
    required this.email,
    required this.firstName,
    required this.lastName,
    this.middleName,
    this.suffix,
    required this.gender,
    required this.birthdate,
    required this.occupation,
    required this.phoneNumber,
    required this.studentId,
    required this.relationship,
  });

  factory PendingRegistration.fromJson(Map<String, dynamic> json) {
    return PendingRegistration(
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      middleName: json['middle_name'],
      suffix: json['suffix'],
      gender: json['gender'] ?? '',
      birthdate: json['birthdate'] ?? '',
      occupation: json['occupation'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      studentId: json['student_id'] ?? '',
      relationship: json['relationship'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'middle_name': middleName,
      'suffix': suffix,
      'gender': gender,
      'birthdate': birthdate,
      'occupation': occupation,
      'phone_number': phoneNumber,
      'student_id': studentId,
      'relationship': relationship,
    };
  }
}