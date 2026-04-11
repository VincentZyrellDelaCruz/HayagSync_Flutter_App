import 'package:hayagsync_app/models/incident/incident_category.dart';
import 'package:hayagsync_app/models/incident/latest_update.dart';
import 'package:hayagsync_app/models/student.dart';
import 'package:hayagsync_app/models/user.dart';

class Incident {
  final String id;
  final String schoolId;
  final String reportedBy;
  final int categoryId;
  final int currentStatusId;

  final String title;
  final String description;
  final DateTime incidentDatetime;

  final String? location;
  final double? latitude;
  final double? longitude;

  final String urgencyLevel;

  final DateTime createdAt;
  final DateTime updatedAt;

  final IncidentCategory? category;
  final User? user;
  final List<Student> students;
  final LatestUpdate? latestUpdate;

  Incident({
    required this.id,
    required this.schoolId,
    required this.reportedBy,
    required this.categoryId,
    required this.currentStatusId,
    required this.title,
    required this.description,
    required this.incidentDatetime,
    this.location,
    this.latitude,
    this.longitude,
    required this.urgencyLevel,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    this.user,
    this.students = const [],
    this.latestUpdate,
  });

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['id'],
      schoolId: json['school_id'],
      reportedBy: json['reported_by'],
      categoryId: json['category_id'],
      currentStatusId: json['current_status_id'],

      title: json['incident_title'] ?? '',
      description: json['description'] ?? '',
      incidentDatetime: DateTime.parse(json['incident_datetime']),

      location: json['location'],

      // STRING → double
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,

      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,

      urgencyLevel: json['urgency_level'] ?? 'Low',

      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),

      category: json['category'] != null
          ? IncidentCategory.fromJson(json['category'])
          : null,

      user: json['user'] != null
          ? User.fromJson(json['user'])
          : null,

      students: (json['students'] as List? ?? [])
          .map((e) => Student.fromJson(e))
          .toList(),

      latestUpdate: json['latest_update'] != null
          ? LatestUpdate.fromJson(json['latest_update'])
          : null,
    );
  }
}