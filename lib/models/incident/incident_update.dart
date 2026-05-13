import 'package:hayagsync_app/models/incident/incident_status.dart';

class IncidentUpdate {
  final String id;
  final String note;

  final String? updatedBy;
  final DateTime? createdAt;

  final IncidentStatus? status;

  IncidentUpdate({
    required this.id,
    required this.note,
    this.updatedBy,
    this.createdAt,
    this.status,
  });

  factory IncidentUpdate.fromJson(Map<String, dynamic> json) {
    return IncidentUpdate(
      id: json['id'],
      note: json['note'] ?? '',
      updatedBy: json['updated_by'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      status: json['incident_status'] != null
          ? IncidentStatus.fromJson(json['incident_status'])
          : null,
    );
  }
}