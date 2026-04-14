import 'package:hayagsync_app/models/student.dart';

class SelectedStudent {
  final Student student;
  String involvementType;
  String? notes;

  SelectedStudent({
    required this.student,
    required this.involvementType,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        "student_id": student.id,
        "involvement_type": involvementType,
        "notes": notes,
      };
}