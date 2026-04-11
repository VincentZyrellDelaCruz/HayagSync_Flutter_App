class IncidentCategory {
  final int id;
  final String categoryName;

  IncidentCategory({
    required this.id,
    required this.categoryName,
  });

  factory IncidentCategory.fromJson(Map<String, dynamic> json) {
    return IncidentCategory(
      id: json['id'],
      categoryName: json['category_name'] ?? '',
    );
  }
}