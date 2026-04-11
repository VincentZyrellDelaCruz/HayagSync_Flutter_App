import 'package:hayagsync_app/models/incident/incident_status.dart';

class IncidentUpdate {
  final String id;
  final String note;
  final IncidentStatus? status;

  IncidentUpdate({
    required this.id,
    required this.note,
    this.status,
  });

  factory IncidentUpdate.fromJson(Map<String, dynamic> json) {
    return IncidentUpdate(
      id: json['id'],
      note: json['note'] ?? '',
      status: json['incident_status'] != null
          ? IncidentStatus.fromJson(json['incident_status'])
          : null,
    );
  }
}