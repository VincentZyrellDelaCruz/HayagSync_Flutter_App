class IncidentStatus {
  final int id;
  final String statusName;
  final String? description;

  IncidentStatus({
    required this.id,
    required this.statusName,
    this.description,
  });

  factory IncidentStatus.fromJson(Map<String, dynamic> json) {
    return IncidentStatus(
      id: json['id'],
      statusName: json['status_name'] ?? '',
      description: json['description'],
    );
  }
}