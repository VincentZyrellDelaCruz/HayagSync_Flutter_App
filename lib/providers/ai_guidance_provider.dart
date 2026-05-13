import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hayagsync_app/models/ai_parenting_support.dart';

final aiGuidanceProvider =
    Provider.family<AiParentingSupport?, dynamic>((ref, incident) {
  return incident.aiGuidance;
});