class IncidentEvidence {
  final String id;
  final String fileName;
  final String filePath;
  final String? fileType;
  final String? caption;

  IncidentEvidence({
    required this.id,
    required this.fileName,
    required this.filePath,
    this.fileType,
    this.caption,
  });

  factory IncidentEvidence.fromJson(Map<String, dynamic> json) {
    return IncidentEvidence(
      id: json['id'],
      fileName: json['file_name'] ?? '',
      filePath: json['file_path'] ?? '',
      fileType: json['file_type'],
      caption: json['caption'],
    );
  }
}