import 'package:hayagsync_app/models/incident/incident_status.dart';

class LatestUpdate {
  final String id;
  final String incidentId;
  final String updatedBy;
  final int statusId;
  final String note;
  final DateTime createdAt;

  final IncidentStatus? incidentStatus;

  LatestUpdate({
    required this.id,
    required this.incidentId,
    required this.updatedBy,
    required this.statusId,
    required this.note,
    required this.createdAt,
    this.incidentStatus,
  });

  factory LatestUpdate.fromJson(Map<String, dynamic> json) {
    return LatestUpdate(
      id: json['id'],
      incidentId: json['incident_id'],
      updatedBy: json['updated_by'],
      statusId: json['status_id'],
      note: json['note'] ?? '',
      createdAt: DateTime.parse(json['created_at']),

      incidentStatus: json['incident_status'] != null
          ? IncidentStatus.fromJson(json['incident_status'])
          : null,
    );
  }
}
