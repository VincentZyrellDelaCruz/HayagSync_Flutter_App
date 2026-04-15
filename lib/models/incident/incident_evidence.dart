class IncidentEvidence {
  final String id;
  final String incidentId;
  final String uploadedBy;

  final String fileName;
  final String filePath;
  final String fileType;
  final int fileSize;
  final String mimeType;

  final String? caption;

  final DateTime createdAt;

  IncidentEvidence({
    required this.id,
    required this.incidentId,
    required this.uploadedBy,
    required this.fileName,
    required this.filePath,
    required this.fileType,
    required this.fileSize,
    required this.mimeType,
    this.caption,
    required this.createdAt,
  });

  factory IncidentEvidence.fromJson(Map<String, dynamic> json) {
    return IncidentEvidence(
      id: json['id'],
      incidentId: json['incident_id'],
      uploadedBy: json['uploaded_by'],
      fileName: json['file_name'] ?? '',
      filePath: json['file_path'] ?? '',
      fileType: json['file_type'] ?? '',
      fileSize: json['file_size'] ?? 0,
      mimeType: json['mime_type'] ?? '',
      caption: json['caption'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}