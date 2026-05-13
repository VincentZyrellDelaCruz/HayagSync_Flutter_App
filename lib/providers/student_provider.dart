import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayagsync_app/models/student.dart';
import 'package:hayagsync_app/services/student_service.dart';

final myStudentsProvider = FutureProvider.autoDispose<List<Student>>((
  ref,
) async {
  return StudentService.getMyStudents();
});

final allStudentsProvider = FutureProvider.autoDispose<List<Student>>((
  ref,
) async {
  return StudentService.getAllStudents();
});
