import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayagsync_app/models/incident/incident_category.dart';
import 'package:hayagsync_app/services/category_service.dart';

final categoryProvider = FutureProvider<List<IncidentCategory>>((ref) async {
  return CategoryService.getCategories();
});
