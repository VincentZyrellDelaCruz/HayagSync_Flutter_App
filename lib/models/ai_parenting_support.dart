class AiParentingSupport {
  final String id;
  final String incidentId;
  final String tipsTitle;
  final String generatedText;

  final DateTime createdAt;
  final DateTime updatedAt;

  const AiParentingSupport({
    required this.id,
    required this.incidentId,
    required this.tipsTitle,
    required this.generatedText,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AiParentingSupport.fromJson(Map<String, dynamic> json) {
    return AiParentingSupport(
      id: json['id'],
      incidentId: json['incident_id'],
      tipsTitle: json['tips_title'] ?? '',
      generatedText: json['generated_text'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}